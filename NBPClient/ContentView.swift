//
//  ContentView.swift
//  NBPClient
//
//  Created by Jacek Kosiński G on 27/11/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State  private var rates = [CurrencyBRates]()
    
    var body: some View {
        

        
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Button("Fetch data") {
                let url = URL(string: "https://api.nbp.pl/api/exchangerates/tables/B")!
                self.fetch(url)
                ForEach(rates) { rate in
                    Text(rate.currency)
                }
            }
        }
        .padding()
    }
    
    func fetch(_ url: URL) {
        URLSession.shared.dataTask(with: url){ data, response, error in
            if let error = error {
                print("Something wrong wit getting data from NBP")
            } else if let data = data {
                // decode and somthing
                print(String(data:data, encoding: .utf8)!)
                
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode([NbpBTable].self, from: data)
                    print("--------------------------------------------")
                    print(result)
                    if (result[0].rates != nil){
                        rates = result[0].rates!
                    }
                } catch {
                    print("Something wrong with JSON decoding")
                }
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



    







struct NbpBTable: Codable, Identifiable {
    
    var table         : String?  = nil
    var id            : String?  = nil
    var effectiveDate : String?  = nil
    var rates         : [CurrencyBRates]? = []
    
    enum CodingKeys: String, CodingKey {
        
        case table         = "table"
        case id            = "no"
        case effectiveDate = "effectiveDate"
        case rates         = "rates"
        
    }
}
    
struct CurrencyBRates: Codable,Identifiable {

  var currency : String? = nil
  var id     : String? = nil
  var mid      : Double? = nil

  enum CodingKeys: String, CodingKey {

    case currency = "currency"
    case id     = "code"
    case mid      = "mid"
  
  }



}
