//
//  ModelSelectionView.swift
//  iosLLmApp
//
//  Created by Sanjay Nelagadde on 1/26/26.
//

import SwiftUI

struct ModelSelectionView: View {
    @State private var selectedModel: ModelOption = .tinyLlama
    @State private var isDownloading = false
    @State private var downloadProgress: Double = 0.0
    @State private var modelPath: String?
    @Environment(\.dismiss) private var dismiss
    
    var onModelSelected: ((String?) -> Void)?
    
    init(onModelSelected: ((String?) -> Void)? = nil) {
        self.onModelSelected = onModelSelected
    }
    
    enum ModelOption: String, CaseIterable {
        case phi3Mini = "Phi-3 Mini"
        case tinyLlama = "TinyLlama"
        case custom = "Custom URL"
        
        var description: String {
            switch self {
            case .phi3Mini:
                return "3.8B parameters, ~2.5GB, Good quality"
            case .tinyLlama:
                return "1.1B parameters, ~700MB, Fast"
            case .custom:
                return "Enter your own model URL"
            }
        }
        
        var downloadURL: URL? {
            switch self {
            case .phi3Mini:
                return URL(string: "https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf/resolve/main/Phi-3-mini-4k-instruct-q4_k_m.gguf")
            case .tinyLlama:
                return URL(string: "https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf")
            case .custom:
                return nil
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Select Model") {
                    Picker("Model", selection: $selectedModel) {
                        ForEach(ModelOption.allCases, id: \.self) { model in
                            VStack(alignment: .leading) {
                                Text(model.rawValue)
                                Text(model.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .tag(model)
                        }
                    }
                    .onChange(of: selectedModel) { _, _ in
                        // Check for existing model when selection changes
                        checkForExistingModel()
                    }
                }
                
                Section {
                    if isDownloading {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Downloading model...")
                            ProgressView(value: downloadProgress)
                            Text("\(Int(downloadProgress * 100))%")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    } else if let path = modelPath {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Model ready!")
                                .font(.headline)
                            Text(path)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("Click 'Done' to use this model")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    } else {
                        Button("Download Model") {
                            downloadModel()
                        }
                        .disabled(selectedModel == .custom)
                    }
                }
                
                Section("MLX Status") {
                    #if canImport(MLX)
                    Label("MLX Swift is available", systemImage: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    #else
                    VStack(alignment: .leading, spacing: 8) {
                        Label("MLX Swift not detected", systemImage: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text("Package is added but products aren't linked to target.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Button("Show Fix Instructions") {
                            // This will be handled by showing an alert or sheet
                        }
                        .font(.caption)
                        .padding(.top, 4)
                    }
                    #endif
                }
                
                Section {
                    Button {
                        // Show diagnostics
                        let diagnostics = MLXDiagnostics.runDiagnostics()
                        print(diagnostics)
                        // In a real app, you'd show this in an alert or sheet
                    } label: {
                        Label("Run Diagnostics", systemImage: "stethoscope")
                    }
                }
                
                Section("Note") {
                    Text("Models require iOS 18+ and Apple Silicon devices. The first download may take several minutes depending on your connection.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Model Setup")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        // Pass the model path back if available
                        onModelSelected?(modelPath)
                        dismiss()
                    }
                    .disabled(modelPath == nil)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                // Check if model already exists
                checkForExistingModel()
            }
        }
    }
    
    private func checkForExistingModel() {
        // Check if the selected model already exists
        let modelName = selectedModel.rawValue.lowercased().replacingOccurrences(of: " ", with: "-")
        if ModelManager.shared.hasModel(modelName) {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let modelFileName = "\(modelName).gguf"
            let localPath = documentsDirectory.appendingPathComponent(modelFileName)
            modelPath = localPath.path
        }
    }
    
    private func downloadModel() {
        guard let url = selectedModel.downloadURL else { return }
        
        isDownloading = true
        downloadProgress = 0.0
        
        Task {
            let modelName = selectedModel.rawValue.lowercased().replacingOccurrences(of: " ", with: "-")
            let path = await ModelManager.shared.getModelPath(
                modelName: modelName,
                from: url
            ) { progress in
                downloadProgress = progress
            }
            
            await MainActor.run {
                isDownloading = false
                modelPath = path
            }
        }
    }
}

#Preview {
    ModelSelectionView()
}
