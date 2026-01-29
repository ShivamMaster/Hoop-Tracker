import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var showingPointSelection = false
    @State private var activeAlert: AlertType?
    @State private var scrollAmount = 0.0

    enum AlertType: Identifiable {
        case reset, undo
        var id: Self { self }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: - Main Controls
                HStack(spacing: 12) {
                    // MISS Button (-)
                    Button(action: {
                        viewModel.addMiss()
                    }) {
                        Image(systemName: "minus")
                            .font(.system(size: 55, weight: .bold)) // Bigger icon
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
                            .font(.system(size: 55, weight: .bold)) // Bigger icon
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
                    

                }
                .padding(.bottom, 17)
                .background(Color.black.opacity(0.5)) // Slight scrim behind stats
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        viewModel.toggleGameMode()
                    }) {
                        Text(viewModel.gameMode.rawValue)
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(6)
                    }
                    .buttonStyle(.plain)
                }
            }
            .ignoresSafeArea(.container, edges: .bottom)
        }
        .focusable()
        .digitalCrownRotation($scrollAmount)
        .onChange(of: scrollAmount) { newValue in
            if newValue > 20.0 {
                // Scroll UP -> RESET Confirmation
                activeAlert = .reset
                scrollAmount = 0
            } else if newValue < -20.0 {
                // Scroll DOWN -> UNDO Confirmation
                activeAlert = .undo
                scrollAmount = 0
            }
        }
        .alert(item: $activeAlert) { alertType in
            switch alertType {
            case .reset:
                return Alert(
                    title: Text("Reset Stats?"),
                    message: Text("This will clear all your points and percentages."),
                    primaryButton: .destructive(Text("Reset")) {
                        viewModel.resetStats()
                    },
                    secondaryButton: .cancel()
                )
            case .undo:
                return Alert(
                    title: Text("Undo Last Action?"),
                    message: Text("Are you sure you want to undo the last action?"),
                    primaryButton: .default(Text("Undo")) {
                        withAnimation {
                            viewModel.undoLastAction()
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
