import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var devices: [Device]
    @EnvironmentObject private var viewModel: DeviceViewModel
    
    @State private var deviceToDelete: Device?
    @State private var isShowingAddDeviceSheet = false
    @State private var isShowingDeleteConfirmation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            Color.blue.opacity(0.3),
                            Color.blue.opacity(0.0),
                            Color.blue.opacity(0.0),
                            Color.blue.opacity(0.0)
                        ]
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack {
                    List {
                        
                        // SECTION: Estimasi
                        Section {
                            NavigationLink {
                                EstimationDetailView()
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Image(systemName: "creditcard.fill")
                                                .foregroundStyle(Color(.blue))
                                                .font(.system(size: 16))
                                            Text("Estimasi Bulanan")
                                                .font(.headline)
                                                .foregroundStyle(Color(.blue))
                                        }
                                        
                                        Text(
                                            devices.isEmpty
                                                ? "Rp 0"
                                                : "Rp \(EstimationHelper.overallMonthlyCost(for: devices, demandCharges: 61_763), specifier: "%.0f")"
                                        )
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundStyle(Color(.label))
                                        
                                        
                                    }
                                }
                                .padding(.vertical, 8)
                                
                            }
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.secondarySystemBackground))
                                    .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                            )
                            
                            
                            HStack(spacing: 10) {
                                // Estimasi Harian
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "sun.max.fill")
                                            .foregroundStyle(Color(.systemOrange))
                                            .font(.system(size: 16))
                                        Text("Harian")
                                            .font(.headline)
                                            .foregroundStyle(Color(.systemOrange))
                                    }
                                    
                                    Text(devices.isEmpty ? "Rp 0" : "Rp \(EstimationHelper.overallDailyCost(for: devices, demandCharges: 61_763), specifier: "%.0f")")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundStyle(Color(.label))
                                    
                                }
                                .padding(.vertical, 15)
                                .padding(.horizontal, 20)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.secondarySystemBackground))
                                )
                                
                                
                                // Estimasi Mingguan
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "calendar")
                                            .foregroundStyle(Color(.systemTeal))
                                            .font(.system(size: 16))
                                        Text("Mingguan")
                                            .font(.headline)
                                            .foregroundStyle(Color(.systemTeal))
                                    }
                                    
                                    
                                    Text(devices.isEmpty ? "Rp 0" : "Rp \(EstimationHelper.overallWeeklyCost(for: devices, demandCharges: 61_763), specifier: "%.0f")")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundStyle(Color(.label))
                                         
                                }
                                .padding(.vertical, 15)
                                .padding(.horizontal, 20)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.secondarySystemBackground))
                                )
                            }
                            
                            .padding(.top, 4)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets())
                            
                        }.listRowSeparator(.hidden)
                        // SECTION: Perangkat
                        Section(header:
                                    HStack {
                            Text("Perangkat yang Digunakan")
                                .font(.title3.bold())
                                .foregroundStyle(Color(.label))
                                .textCase(.none)
                            
                            Spacer()
                            
                            Text("\(devices.count)")
                                .font(.subheadline.bold())
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(Color(.systemGray5))
                                )
                        }
                            .padding(.bottom, 8)
                            .padding(.top, 8)
                        ) {
                            
                            if (devices.isEmpty) {
                                Text("Daftar perangkat kosong. Silakan input perangkat Anda.")
                                    .font(.footnote)
                                    .foregroundStyle(Color(.secondaryLabel))
                                    .frame(maxWidth: .infinity)
                                    .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(12)
                            }
                            
                            ForEach(devices) { device in
                                NavigationLink(destination: DeviceDetailView(device: device)) {
                                    HStack(spacing: 16) {
                                        ZStack {
                                            Circle()
                                                .fill(Color(.blue).opacity(0.2))
                                                .frame(width: 40, height: 40)
                                            
                                            Image(systemName: DeviceIconMapper.detectIcon(for: device.name))
                                                .font(.system(size: 18))
                                                .foregroundColor(Color(.blue))
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(device.name)
                                                .font(.headline)
                                            
                                            Text("\(device.powerConsumption) Watt • \(device.usageDuration) \(device.usageUnit.rawValue)")
                                                .font(.subheadline)
                                                .foregroundColor(Color(.systemGray))
                                        }
                                        
                                        Spacer()
                                        
                                        let powerLevel = min(Double(device.powerConsumption) / 1000, 1.0)
                                        Circle()
                                            .fill(
                                                powerLevel < 0.3 ? Color(.systemGreen) :
                                                    powerLevel < 0.7 ? Color(.systemYellow) : Color(.systemRed)
                                            )
                                            .frame(width: 10, height: 10)
                                    }
                                    .padding(.vertical, 4)
                                }
                                .listRowBackground(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.secondarySystemBackground))
                                        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                                )
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .cancel) {
                                        deviceToDelete = device
                                        isShowingDeleteConfirmation = true
                                    } label: {
                                        
                                        Image(systemName: "trash.fill")
                                            .foregroundStyle(Color.red)
                                    }
                                    .tint(Color.clear)
                                }
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                    .listStyle(.insetGrouped)
                    .navigationTitle("Estimasi Tagihan")
                    .toolbar {
                        ToolbarItem {
                            Button(action: {
                                isShowingAddDeviceSheet.toggle()
                            }) {
                                Image(systemName: "plus")
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                }
                .sheet(isPresented: $isShowingAddDeviceSheet) {
                    AddDeviceView(isPresented: $isShowingAddDeviceSheet)
                }
                .confirmationDialog("Apakah Anda yakin ingin menghapus perangkat ini?", isPresented: $isShowingDeleteConfirmation, titleVisibility: .visible) {
                    Button("Hapus", role: .destructive) {
                        if let device = deviceToDelete {
                            viewModel.deleteDevice(device)
                            deviceToDelete = nil
                        }
                    }
                    
                    Button("Batal", role: .cancel) {
                        deviceToDelete = nil
                    }
                }
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Device.self, configurations: config)
        let context = container.mainContext
        let viewModel = DeviceViewModel(modelContext: context)
        
        viewModel.addDevice(name: "AC Kamar", powerConsumption: 789, usageDuration: 5, frequencyPerMonth: 30, usageUnit: .hours)
        viewModel.addDevice(name: "Komputer", powerConsumption: 450, usageDuration: 8, frequencyPerMonth: 20, usageUnit: .hours)
        viewModel.addDevice(name: "TV", powerConsumption: 120, usageDuration: 4, frequencyPerMonth: 30, usageUnit: .hours)
        
        return MainView()
            .modelContainer(container)
            .environmentObject(viewModel)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}


extension View {
    func hideKeyboardWhenTappedAround() -> some View {
        return self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
