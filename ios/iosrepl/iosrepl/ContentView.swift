//
//  ContentView.swift
//  iosrepl
//
//  Created by Bogdan Popa on 12/01/2021.
//

import SwiftUI

struct ContentView: View {
    @State var code = ""
    @State var res = ""

    var body: some View {
        VStack {
            TextField("REPL", text: $code)
                .padding()
            Text(res)
                .padding()
            Button(action: eval) {
                Text("Eval")
            }
        }
    }

    func eval() {
        var out = UnsafeMutablePointer<Int8>.allocate(capacity: 512)
        var inp = strdup(code)
        DispatchQueue.main.async {
            print(repl_eval(UnsafeMutablePointer(inp), out, 512))
            let s = String.init(cString: out)
            res = s
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
