import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var showingPointSelection = false
    @State private var showingResetConfirmation = false
    
    var body: some View {
        VStack {
            // MARK: - Top Bar (Mode Toggle)
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        viewModel.toggleGameMode()
                    }
                }) {
                    Text(viewModel.gameMode.rawValue)
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.top, 5)
            .padding(.horizontal)
            
            // MARK: - Main Controls
            HStack(spacing: 10) {
                // MISS Button (-)
                Button(action: {
                    viewModel.addMiss()
                }) {
                    Image(systemName: "minus")
                        .font(.system(size: 40, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                }
                .background(Color.red.opacity(0.8))
                .cornerRadius(20)
                
                // MAKE Button (+)
                Button(action: {
                    showingPointSelection = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 40, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                }
                .background(Color.green.opacity(0.8))
                .cornerRadius(20)
                .sheet(isPresented: $showingPointSelection) {
                    PointSelectionView(viewModel: viewModel, isPresented: $showingPointSelection)
                }
            }
            .frame(maxHeight: .infinity)
            .padding(.horizontal)
            
            // MARK: - Stats Dashboard
            VStack(spacing: 4) {
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
                
                // Reset Button (Small, discrete)
                Button(action: {
                    showingResetConfirmation = true
                }) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .padding(5)
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
