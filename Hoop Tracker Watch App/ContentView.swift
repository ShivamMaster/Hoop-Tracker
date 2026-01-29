import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var showingPointSelection = false
    @State private var showingResetConfirmation = false
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Top Bar (Mode Toggle)
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        viewModel.toggleGameMode()
                    }
                }) {
                    Text(viewModel.gameMode.rawValue)
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.top, 5)
            .padding(.horizontal)
            
            // MARK: - Main Controls
            HStack(spacing: 12) {
                // MISS Button (-)
                Button(action: {
                    viewModel.addMiss()
                }) {
                    Image(systemName: "minus")
                        .font(.system(size: 50, weight: .bold)) // Bigger icon
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                }
                .background(Color.red.opacity(0.8))
                .cornerRadius(25)
                
                // MAKE Button (+)
                Button(action: {
                    showingPointSelection = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 50, weight: .bold)) // Bigger icon
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                }
                .background(Color.green.opacity(0.8))
                .cornerRadius(25)
                .sheet(isPresented: $showingPointSelection) {
                    PointSelectionView(viewModel: viewModel, isPresented: $showingPointSelection)
                }
            }
            .frame(maxHeight: .infinity)
            .padding(.horizontal, 8) // Reduced padding for bigger buttons
            .padding(.vertical, 5)
            
            // MARK: - Stats Dashboard
            VStack(spacing: 8) {
                HStack {
                    VStack {
                        Text("\(viewModel.totalPoints)")
                            .font(.title2)
                            .fontWeight(.heavy)
                            .foregroundColor(.yellow)
                        Text("PTS")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("\(viewModel.madeShots)/\(viewModel.totalAttempts)")
                            .font(.headline)
                        Text("M/A")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text(viewModel.formattedPercentage)
                            .font(.headline)
                        Text("%")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                // MARK: - Bottom Actions (Reset & Undo)
                HStack(spacing: 20) {
                    // Reset Button
                    Button(action: {
                        showingResetConfirmation = true
                    }) {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Reset")
                        }
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(Color.red.opacity(0.2))
                        .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .alert(isPresented: $showingResetConfirmation) {
                        Alert(
                            title: Text("Reset Stats?"),
                            message: Text("This will clear all your points and percentages."),
                            primaryButton: .destructive(Text("Reset")) {
                                viewModel.resetStats()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    
                    // Undo Button
                    Button(action: {
                        withAnimation {
                            viewModel.undoLastAction()
                        }
                    }) {
                        HStack {
                            Image(systemName: "arrow.uturn.backward")
                            Text("Undo")
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(viewModel.actionHistory.isEmpty)
                    .opacity(viewModel.actionHistory.isEmpty ? 0.5 : 1.0)
                }
            }
            .padding(.bottom, 5)
            .background(Color.black.opacity(0.5)) // Slight scrim behind stats
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
