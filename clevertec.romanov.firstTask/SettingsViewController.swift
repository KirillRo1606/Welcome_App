import UIKit
import SnapKit

struct Language {
    private let code: String
    private let language: String

    init(code: String, language: String) {
        self.code = code
        self.language = language
    }

    func getCode() -> String {
        return code
    }

    func getLanguage() -> String {
        return language
    }
}

final class SettingsViewController: UIViewController {
    
// MARK: - Properties
    
    struct Constants {
        static let backgroundColor = UIColor(named: "backgroundColor")
        static let textColor = UIColor(named: "textColor")
        static let buttonColor = UIColor(named: "buttonColor")
        static let selectedButtonColor = UIColor(named: "selectedButtonColor")
        static let iconImage = UIImage(named: "rocketLaunch.png")
        static let defaultLenguage = "en"
        static let welcomeTitle = "welcome.title"
        static let lightButtonTitle = "lightButton.title"
        static let darkButtonTitle = "darkButton.title"
        static let autoButtonTitle = "autoButton.title"
    }
    
    private let supportedLanguages = [
        Language(code: "en", language: "English"),
        Language(code: "be", language: "Беларуская"),
        Language(code: "ru", language: "Русский")
    ]
    
// MARK: - UI Elements
    
    private var mainView = UIView()
    
    private let elementsStackView: UIStackView = {
        let elementsStackView = UIStackView()
        elementsStackView.axis = .vertical
        elementsStackView.alignment = .center
        elementsStackView.spacing = 10
        return elementsStackView
    }()
    
    private let iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.image = Constants.iconImage
        return iconImageView
    }()
    
    private let welcomeLabel: UILabel = {
        let welcomeLabel = UILabel()
        welcomeLabel.textColor = Constants.textColor
        welcomeLabel.font = .systemFont(ofSize: 30)
        return welcomeLabel
    }()
    
    private let languagePicker = UIPickerView()
    
    private let themeModeStackView: UIStackView = {
        let themeModeStackView = UIStackView()
        themeModeStackView.axis = .horizontal
        themeModeStackView.alignment = .center
        themeModeStackView.spacing = 10
        themeModeStackView.contentMode = .scaleToFill
        themeModeStackView.distribution = .fillEqually
        return themeModeStackView
    }()
    
    
    private let lightModeButtom: UIButton = {
        let lightModeButtom = UIButton()
        lightModeButtom.backgroundColor = Constants.buttonColor
        return lightModeButtom
    }()
    
    private let darkModeButton: UIButton = {
        let darkModeButton = UIButton()
        darkModeButton.backgroundColor = Constants.buttonColor
        return darkModeButton
    }()
    
    private let autoModeButton: UIButton = {
        let autoModeButton = UIButton()
        autoModeButton.backgroundColor = Constants.selectedButtonColor
        return autoModeButton
    }()
   
// MARK: - View Did Load Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        addConstraints()
        setLanguage(str: Constants.defaultLenguage)
    }
}

// MARK: - Language Picker Methods

extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        supportedLanguages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        supportedLanguages[row].getLanguage()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setLanguage(str: supportedLanguages[row].getCode())
    }
    
    private func addLanguagePicker() {
        languagePicker.delegate = self
        languagePicker.dataSource = self
    }
}

// MARK: - Buttons Methods

extension SettingsViewController {
    private func addButtons() {
        [lightModeButtom, darkModeButton, autoModeButton].forEach { button in
            button.setTitleColor(Constants.textColor, for: .normal)
            button.setTitleColor(.gray, for: .highlighted)
            button.layer.cornerRadius = 15
            button.addTarget(self, action: #selector(changeMode(sender:)), for: .touchUpInside)
            themeModeStackView.addArrangedSubview(button)
        }
    }
    
    @objc func changeMode(sender: UIButton) {
        lightModeButtom.backgroundColor = Constants.buttonColor
        darkModeButton.backgroundColor = Constants.buttonColor
        autoModeButton.backgroundColor = Constants.buttonColor
        
        if sender == lightModeButtom {
            view.overrideUserInterfaceStyle = .light
            lightModeButtom.backgroundColor = Constants.selectedButtonColor
        }
        if sender == darkModeButton {
            view.overrideUserInterfaceStyle = .dark
            darkModeButton.backgroundColor = Constants.selectedButtonColor
        }
        if sender == autoModeButton {
            view.overrideUserInterfaceStyle = .unspecified
            autoModeButton.backgroundColor = Constants.selectedButtonColor
        }
    }
}

// MARK: - Init Dependencies

extension SettingsViewController {
    private func addViews() {
        addLanguagePicker()
        addButtons()
        view.addSubview(mainView)
        mainView.addSubview(elementsStackView)
        [iconImageView, welcomeLabel, languagePicker, themeModeStackView].forEach { element in
            elementsStackView.addArrangedSubview(element)
        }
    }
}

// MARK: - Add Constraints Method

extension SettingsViewController {
    private func addConstraints() {
        view.backgroundColor = Constants.backgroundColor
        mainView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        elementsStackView.snp.makeConstraints { make in
            make.center.equalTo(self.mainView)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(100)
        }
        
        themeModeStackView.snp.makeConstraints { make in
            make.width.equalTo(self.elementsStackView)
        }
    }
}

// MARK: - Set Language Method

extension SettingsViewController {
    private func setLanguage(str: String) {
        welcomeLabel.text = Constants.welcomeTitle.addLocalizableString(str: str)
        lightModeButtom.setTitle(Constants.lightButtonTitle.addLocalizableString(str: str), for: .normal)
        darkModeButton.setTitle(Constants.darkButtonTitle.addLocalizableString(str: str), for: .normal)
        autoModeButton.setTitle(Constants.autoButtonTitle.addLocalizableString(str: str), for: .normal)
    }
}

// MARK: - Localization

extension String {
    func addLocalizableString(str: String) -> String {
        var localizableString = ""
        if let path = Bundle.main.path(forResource: str, ofType: "lproj") {
            if let bundle = Bundle(path: path) {
                localizableString = NSLocalizedString(self, bundle: bundle, comment: "")
            }
        }
        return localizableString
    }
}
