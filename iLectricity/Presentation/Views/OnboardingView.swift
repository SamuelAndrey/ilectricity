//
//  OnboardingView.swift
//  iLectricity
//
//  Created by Samuel Andrey Aji Prasetya on 20/06/26.
//

import SwiftUI

struct OnboardingView: View {

    @AppStorage(UserDefaultsKeys.hasCompletedOnboarding) private var hasCompletedOnboarding = false

    @State private var step: Int = 0
    @State private var tariff: Int = UserDefaults.standard.integer(forKey: UserDefaultsKeys.tariffPerKwh)
    @State private var billingDay: Int = UserDefaults.standard.integer(forKey: UserDefaultsKeys.resetDate)

    @State private var offsetX: CGFloat = 0
    @State private var opacity: Double = 1

    private let totalSteps = 3

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundGradient
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    progressBar
                        .padding(.top, geometry.safeAreaInsets.top + 8)
                        .padding(.horizontal, 32)

                    Spacer(minLength: 0)

                    contentView(size: geometry.size)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity))
                        )
                        .id(step)
                        .animation(.spring(response: 0.55, dampingFraction: 0.85), value: step)

                    Spacer(minLength: 0)

                    bottomAction(geometry: geometry)
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 24)
                }
            }
        }
        .animation(.spring(response: 0.55, dampingFraction: 0.85), value: step)
    }

    // MARK: - Background

    private var backgroundGradient: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.green.opacity(0.5),
                    Color.green.opacity(0.08),
                    Color.green.opacity(0.03),
                    Color.secondary.opacity(0.06),
                    Color.secondary.opacity(0.08),
                ]),
                startPoint: .top, endPoint: .bottom
            )

            RadialGradient(
                gradient: Gradient(colors: [
                    Color.green.opacity(0.25),
                    Color.clear,
                ]),
                center: .top,
                startRadius: 0,
                endRadius: 400
            )
        }
    }

    // MARK: - Progress Bar

    private var progressBar: some View {
        HStack(spacing: 6) {
            ForEach(0..<totalSteps, id: \.self) { index in
                Capsule()
                    .fill(index <= step ? Color.green : Color.green.opacity(0.2))
                    .frame(width: index == step ? 32 : 8, height: 8)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: step)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Content

    @ViewBuilder
    private func contentView(size: CGSize) -> some View {
        switch step {
        case 0:
            welcomeContent(size: size)
        case 1:
            tariffContent
        case 2:
            billingDateContent
        default:
            EmptyView()
        }
    }

    private func welcomeContent(size: CGSize) -> some View {
        VStack(spacing: 0) {
            heroSectionOne

            Text("iLectricity")
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.top, 32)

            Text("Understand every watt of\nyour electricity bill")
                .font(.title3)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 12)
                .padding(.horizontal, 40)

            HStack(spacing: 28) {
                featureItem(icon: "house.fill", text: "Log Devices")
                featureItem(icon: "chart.bar.fill", text: "Estimate Costs")
                featureItem(icon: "calendar.badge.checkmark", text: "Track Usage")
            }
            .padding(.top, 40)
        }
    }

    private var heroSectionOne: some View {
        ZStack {
            Image(systemName: "leaf.circle.fill")
                .resizable()
                .frame(width: 160, height: 160)
                .foregroundColor(.green.opacity(0.08))
                .rotationEffect(.degrees(15))
                .offset(x: -80, y: -20)

            Image(systemName: "leaf.circle.fill")
                .resizable()
                .frame(width: 120, height: 120)
                .foregroundColor(.green.opacity(0.06))
                .rotationEffect(.degrees(-20))
                .offset(x: 70, y: 20)

            Layer1Animator { phase in
                ZStack {
                    Circle()
                        .stroke(Color.green.opacity(0.12), lineWidth: 2)
                        .frame(width: 130 + phase * 8, height: 130 + phase * 8)
                        .opacity(1 - phase * 0.45)

                    Circle()
                        .stroke(Color.green.opacity(0.07), lineWidth: 1.5)
                        .frame(width: 150 + phase * 6, height: 150 + phase * 6)
                        .opacity(0.6 - phase * 0.3)

                    Circle()
                        .fill(Color.green.opacity(0.13))
                        .frame(width: 94, height: 94)

                    Image(systemName: "bolt.fill")
                        .font(.system(size: 38, weight: .medium))
                        .foregroundColor(.green)
                }
            }

            FloatingSymbol(symbol: "lightbulb.fill", x: -62, y: -52, delay: 0, color: .yellow.opacity(0.7), size: 20)
            FloatingSymbol(symbol: "sparkles", x: 58, y: -44, delay: 0.6, color: .green.opacity(0.5), size: 16)
            FloatingSymbol(symbol: "wave.3.right", x: -68, y: 48, delay: 1.0, color: .green.opacity(0.4), size: 14)
            FloatingSymbol(symbol: "bolt.horizontal.fill", x: 72, y: 50, delay: 1.4, color: .green.opacity(0.5), size: 18)
            FloatingSymbol(symbol: "circle.grid.cross.fill", x: 0, y: -68, delay: 1.8, color: .green.opacity(0.35), size: 12)
            FloatingSymbol(symbol: "sparkle", x: -30, y: 68, delay: 2.2, color: .green.opacity(0.45), size: 11)
        }
        .frame(width: 260, height: 220)
    }

    private func featureItem(icon: String, text: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.green)
                .frame(width: 48, height: 48)
                .background(
                    Circle()
                        .fill(Color.green.opacity(0.1))
                )

            Text(text)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
    }

    private var tariffContent: some View {
        VStack(spacing: 0) {
            ZStack {
                Image(systemName: "indianrupeesign.circle")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.green.opacity(0.1))

                VStack(spacing: 4) {
                    Image(systemName: "bolt.badge.clock.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.green)

                    Text("PER KWH")
                        .font(.caption2)
                        .fontWeight(.heavy)
                        .foregroundColor(.green.opacity(0.6))
                        .tracking(4)
                }
            }
            .padding(.bottom, 24)

            Text("Set your electricity rate")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)

            Text("This determines how your estimated costs are calculated. You can always change it later.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 36)
                .padding(.top, 10)

            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text("Rp")
                    .font(.title2)
                    .foregroundColor(.green)

                TextField("", value: $tariff, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 52, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .frame(width: 170)
                    .fixedSize()
            }
            .padding(.top, 36)

            HStack(spacing: 6) {
                Button { tariff = max(0, tariff - 100) } label: {
                    adjustButtonLabel("-")
                }
                Button { tariff = max(0, tariff - 10) } label: {
                    adjustButtonLabel("-")
                }

                Spacer().frame(width: 20)

                Button { tariff += 10 } label: {
                    adjustButtonLabel("+")
                }
                Button { tariff += 100 } label: {
                    adjustButtonLabel("+")
                }
            }
            .padding(.top, 20)

            Text("Default: Rp 1.262/kWh")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 16)
        }
    }

    private func adjustButtonLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(.title3, design: .rounded, weight: .medium))
            .foregroundColor(.green)
            .frame(width: 44, height: 44)
            .background(
                Circle()
                    .fill(Color.green.opacity(0.1))
            )
    }

    private var billingDateContent: some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 80, height: 90)

                VStack(spacing: -2) {
                    Text("\(billingDay)")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.green)

                    Rectangle()
                        .fill(Color.green.opacity(0.3))
                        .frame(width: 36, height: 4)
                        .clipShape(Capsule())

                    Text(Calendar.current.monthSymbols[Calendar.current.component(.month, from: Date()) - 1].prefix(3).uppercased())
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.green.opacity(0.75))
                        .tracking(2)
                        .padding(.top, 4)
                }
            }
            .padding(.bottom, 24)

            Text("When does your\ncycle reset?")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)

            Text("Pick the date your electricity bill is issued each month. This helps us align the estimation period.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 36)
                .padding(.top, 10)

            Picker("Billing Date", selection: $billingDay) {
                ForEach(1...28, id: \.self) { day in
                    Text("\(day)").tag(day)
                        .font(.title3)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 140)
            .padding(.horizontal, 40)
            .padding(.top, 16)

            Text("Every \(billingDay.ordinal) of the month")
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(.green)
                .padding(.top, 4)
        }
    }

    // MARK: - Bottom Action

    @ViewBuilder
    private func bottomAction(geometry: GeometryProxy) -> some View {
        if step < totalSteps - 1 {
            Button {
                advanceStep()
            } label: {
                Text("Continue")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .padding(.horizontal, 32)
        } else {
            VStack(spacing: 14) {
                Button {
                    UserDefaults.standard.set(tariff, forKey: UserDefaultsKeys.tariffPerKwh)
                    UserDefaults.standard.set(billingDay, forKey: UserDefaultsKeys.resetDate)
                    withAnimation(.easeInOut(duration: 0.5)) {
                        hasCompletedOnboarding = true
                    }
                } label: {
                    Text("Start Tracking")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }

                Button {
                    UserDefaults.standard.set(tariff, forKey: UserDefaultsKeys.tariffPerKwh)
                    UserDefaults.standard.set(billingDay, forKey: UserDefaultsKeys.resetDate)
                    hasCompletedOnboarding = true
                } label: {
                    Text("Use defaults")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 32)
        }
    }

    private func advanceStep() {
        withAnimation(.spring(response: 0.55, dampingFraction: 0.85)) {
            step = min(step + 1, totalSteps - 1)
        }
    }
}

// MARK: - Animated Layer

private struct Layer1Animator<Content: View>: View {
    @State private var phase: Double = 0
    let content: (Double) -> Content

    var body: some View {
        content(phase)
            .onAppear {
                withAnimation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true)) {
                    phase = 1
                }
            }
    }
}

private struct FloatingSymbol: View {
    let symbol: String
    let x: CGFloat
    let y: CGFloat
    let delay: Double
    let color: Color
    let size: CGFloat

    @State private var appeared = false

    var body: some View {
        Image(systemName: symbol)
            .font(.system(size: size))
            .foregroundColor(color)
            .offset(x: x, y: y + (appeared ? 0 : 20))
            .opacity(appeared ? 1 : 0)
            .scaleEffect(appeared ? 1 : 0.4)
            .onAppear {
                withAnimation(.spring(response: 0.7, dampingFraction: 0.6).delay(delay)) {
                    appeared = true
                }
            }
    }
}
