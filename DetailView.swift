import SwiftUI

struct DetailView: View {
    @Binding var item: ToDoItem
    
    var body: some View {
        VStack {
            if let imageData = item.imageData, let image = ToDoItem.dataToImage(imageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                    .padding()
            }
            Text(item.title)
                .font(.largeTitle)
                .padding()
            Text(item.body)
                .padding()
        }
        .navigationTitle("Detail")
    }
}



