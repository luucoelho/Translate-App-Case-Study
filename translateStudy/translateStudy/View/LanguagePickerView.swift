//
//  LanguagePickerView.swift
//  translateStudy
//
//  Created by Raphael Ferezin Kitahara on 24/05/23.
//

import SwiftUI

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct LanguagePickerView: View {
    @EnvironmentObject var translationManager: TranslationManager
//    @EnvironmentObject var speechRecognizer: SpeechRecognizer

    @Environment(\.colorScheme) var colorScheme
    var pickerID: Int
    @Binding var selectedLanguage: Int

    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(colorScheme == .dark ? Color(.systemGray6) : .white)
            .frame(height: 50)
            .overlay {
                HStack {
                    // button with language name
                    Button {
                        if selectedLanguage != -1 || pickerID == 1{
                            translationManager.swapLanguages()
                        }
                        selectedLanguage = pickerID
                        
                    } label: {
                        HStack {
                            if selectedLanguage == pickerID {
                                Image(systemName: "smallcircle.filled.circle.fill")
                                    .foregroundStyle(.teal, .teal.opacity(0.5))
                                    .font(.subheadline)
                                    .padding(.leading)
                            } else {
                                Image(systemName: "smallcircle.filled.circle.fill")
                                    .foregroundColor(colorScheme == .dark ? Color(.systemGray6) : .white)
                                    .font(.subheadline)
                                    .padding(.leading)
                            }
                            
                            
                            VStack(alignment: .leading) {
                              
                                if let languageName = ((pickerID == selectedLanguage) || (pickerID == 0 && selectedLanguage == -1) ? translationManager.sourceLanguage.name : translationManager.targetLanguage.name){
                                    Text(languageName)
                                        .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                }
                            }
                            
                            Spacer()
                        }
                    }
                    .disabled(selectedLanguage == pickerID)
                    .padding(.trailing, 0)
                    
                    // divider
                    Rectangle()
                        .foregroundColor(Color(colorScheme == .dark ? .systemGray3 : .systemGray6))
                        .foregroundColor(Color(.systemGray6))
                        .padding(.vertical, 0)
                        .frame(width: 2)
                    
                    // picker button
                    Menu {
                        Picker(selection: ((pickerID == selectedLanguage) || (pickerID == 0 && selectedLanguage == -1) ? $translationManager.sourceLanguage : $translationManager.targetLanguage), label: Text("")) {
                            ForEach(translationManager.supportedLanguages, id: \.self) { language in // 4
                                if let languageName = language.name {
                                    Text(languageName).tag(String?.none)
                                }
                            }
                        }
                    }
                    
                label: {
                    Label("", systemImage: "chevron.down")
                        .foregroundColor(.cyan)
                        .font(.callout)
                        .padding(.bottom, 2)
                }
                }
            }
    }
    
    
}
