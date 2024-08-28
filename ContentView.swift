import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ToDoViewModel()
    @State private var newTitle: String = ""
    @State private var newBody: String = ""
    @State private var showImagePicker: Bool = false
    @State private var selectedImage: UIImage? = nil
    @State private var reminderDate: Date = Date()
    @State private var selectedItem: ToDoItem?
    @State private var selectedDaysOfWeek: Set<Int> = []
    @State private var showScrollIndicator: Bool = true

    let daysOfWeek: [String] = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        return formatter.shortWeekdaySymbols
    }()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                daysOfWeekScroller
                mainForm
                todoList
            }
            .navigationTitle(NSLocalizedString("to_do_list_title", comment: ""))
            .padding()
        }
        .sheet(item: $selectedItem) { item in
            DetailView(item: Binding(
                get: { item },
                set: { newItem in
                    if let index = viewModel.items.firstIndex(where: { $0.id == newItem.id }) {
                        viewModel.items[index] = newItem
                    }
                }
            ))
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
    }
    
    private var daysOfWeekScroller: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(0..<daysOfWeek.count, id: \.self) { index in
                            dayButton(for: index)
                        }
                    }
                    .padding(.horizontal)
                    .background(Color(UIColor.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            let totalWidth = CGFloat(daysOfWeek.count) * 60 + 12 * CGFloat(daysOfWeek.count - 1)
                            showScrollIndicator = geometry.size.width < totalWidth
                        }
                    }
                }

                if showScrollIndicator {
                    Rectangle()
                        .frame(height: 4)
                        .foregroundColor(Color.gray.opacity(0.5))
                        .cornerRadius(2)
                        .padding(.horizontal)
                }
            }
        }
        .frame(height: 60) // Adjust the height as needed
    }

    private var mainForm: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                TextField(NSLocalizedString("enter_new_item", comment: ""), text: $newTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)

                Button(action: {
                    showImagePicker = true
                }) {
                    Image(systemName: "photo.on.rectangle")
                        .font(.system(size: 30))
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                }
                .padding(.trailing, 12)
            }

            TextField(NSLocalizedString("enter_details", comment: ""), text: $newBody)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)

            DatePicker(NSLocalizedString("set_reminder_time", comment: ""), selection: $reminderDate, displayedComponents: .hourAndMinute)
                .datePickerStyle(CompactDatePickerStyle())
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)

            Button(action: {
                addItem()
            }) {
                Text(NSLocalizedString("add_item_button", comment: ""))
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }

    private var todoList: some View {
        List(viewModel.items) { item in
            HStack {
                if let imageData = item.imageData, let image = ToDoItem.dataToImage(imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                }
                VStack(alignment: .leading) {
                    Text(item.title)
                        .font(.headline)
                    if let date = item.reminderDate {
                        Text("Reminder at \(date.formatted(date: .omitted, time: .shortened))")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                    Text("Days: \(item.daysOfWeek.map { dayName(for: $0) }.joined(separator: ", "))")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                selectedItem = item
            }
        }
    }
    
    private func dayButton(for index: Int) -> some View {
        Button(action: {
            toggleDay(index)
        }) {
            Text(dayName(for: index))
                .font(.headline)
                .frame(width: 50, height: 40)
                .background(selectedDaysOfWeek.contains(index) ? Color.blue : Color.gray.opacity(0.3))
                .foregroundColor(.white)
                .clipShape(Capsule())
        }
    }

    private func dayName(for index: Int) -> String {
        let dayNames = [
            NSLocalizedString("day_sun", comment: ""),
            NSLocalizedString("day_mon", comment: ""),
            NSLocalizedString("day_tue", comment: ""),
            NSLocalizedString("day_wed", comment: ""),
            NSLocalizedString("day_thu", comment: ""),
            NSLocalizedString("day_fri", comment: ""),
            NSLocalizedString("day_sat", comment: "")
        ]
        return dayNames[index]
    }
    
    private func toggleDay(_ index: Int) {
        if selectedDaysOfWeek.contains(index) {
            selectedDaysOfWeek.remove(index)
        } else {
            selectedDaysOfWeek.insert(index)
        }
    }
    
    private func addItem() {
        guard !newTitle.isEmpty else { return }
        viewModel.addItem(title: newTitle, body: newBody, image: selectedImage, reminderDate: reminderDate, daysOfWeek: Array(selectedDaysOfWeek))
        newTitle = ""
        newBody = ""
        selectedImage = nil
        selectedDaysOfWeek = []
    }
}
