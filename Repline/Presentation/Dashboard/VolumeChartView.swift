import SwiftUI
import Charts

/// Daily tonnage bar chart and cumulative tower-growth line.
struct VolumeChartView: View {
    let series: [VolumeDataPoint]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Daily Volume")
                .font(.system(.headline, design: .rounded, weight: .bold))
                .foregroundStyle(AppColor.text)

            Chart(series) { point in
                BarMark(
                    x: .value("Day", point.day, unit: .day),
                    y: .value("Volume", point.tonnage)
                )
                .foregroundStyle(AppColor.primary.gradient)
                .cornerRadius(6)
            }
            .frame(height: 160)
            .chartYAxis { AxisMarks(position: .leading) }

            Text("Tower Growth")
                .font(.system(.headline, design: .rounded, weight: .bold))
                .foregroundStyle(AppColor.text)
                .padding(.top, 8)

            Chart(series) { point in
                AreaMark(
                    x: .value("Day", point.day, unit: .day),
                    y: .value("Height", point.cumulativeTonnage)
                )
                .foregroundStyle(AppColor.secondary.opacity(0.25).gradient)
                LineMark(
                    x: .value("Day", point.day, unit: .day),
                    y: .value("Height", point.cumulativeTonnage)
                )
                .foregroundStyle(AppColor.secondary)
                .lineStyle(StrokeStyle(lineWidth: 2.5))
            }
            .frame(height: 160)
            .chartYAxis { AxisMarks(position: .leading) }
        }
        .padding(16)
        .claySurface(fill: AppColor.surface)
        .padding(.horizontal, 16)
    }
}

#Preview {
    VolumeChartView(series: [
        VolumeDataPoint(day: .now.addingTimeInterval(-86_400 * 2), tonnage: 1200, cumulativeTonnage: 1200),
        VolumeDataPoint(day: .now.addingTimeInterval(-86_400), tonnage: 1800, cumulativeTonnage: 3000),
        VolumeDataPoint(day: .now, tonnage: 1500, cumulativeTonnage: 4500),
    ])
    .background(AppColor.background)
}
