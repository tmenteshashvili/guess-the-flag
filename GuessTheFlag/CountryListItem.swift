//
//  CountryListItem.swift
//  GuessTheFlag
//
//  Created by Tako Menteshashvili on 28.11.22.
//

import SwiftUI

struct CountryListItem: View {
    var country: Country
    var state: CountryListItemState = CountryListItemState.normal;
    
    var body: some View {
        AsyncImage(url: URL(string: country.flags.png)) { image in
            image
                .resizable()
                .scaledToFit()
                .rotation3DEffect(.degrees(state == CountryListItemState.selected ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                .opacity(state == CountryListItemState.blurred ? 0.25 : 1)
                .blur(radius: state == CountryListItemState.blurred ? 3 : 0 )
                .animation(.default, value: state != CountryListItemState.normal)
        } placeholder: {
            Color.gray
        }
        
    }
}

struct CountryListItem_Previews: PreviewProvider {
    static var previews: some View {
        let flag = CountryFlag(png: "https://flagcdn.com/w320/ge.png", svg: "https://flagcdn.com//ge.svg");
        let country = Country(name: CountryName(common: "Georgia"), flags: flag);
        CountryListItem(country: country)
    }
}
