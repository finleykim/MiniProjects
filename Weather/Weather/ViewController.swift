
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var weatherStackView: UIStackView!
    @IBAction func tapFetchWeatherButton(_ sender: Any) {
        //버튼을 누르면 도시이름을 getCurrentWeather메서드의 파라미터에 전달해서 현재도시의 날씨정보를 가져오도록
        if let cityName = self.cityNameTextField.text { //텍스트필드의 텍스트 가져온다
            self.getCurrentWeather(cityName: cityName)
            self.view.endEditing(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureView(weatherInformation: WeatherInformation){
        self.cityNameLabel.text = weatherInformation.name //도시이름이 표시되도록
        //weather의 첫번째요소를 weather상수에 할당
        if let weather = weatherInformation.weather.first {
            self.weatherDescriptionLabel.text = weather.description
        }
        self.tempLabel.text = "\(Int(weatherInformation.temp.temp - 273.15))°C"
        self.maxTempLabel.text = "최저: \(Int(weatherInformation.temp.minTemp - 273.15))°C"
        self.minTempLabel.text = "최저: \(Int(weatherInformation.temp.maxTemp - 273.15))°C"
        
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func getCurrentWeather(cityName: String){
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else { return }
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apiKey)") else { return }
        let session = URLSession(configuration: .default)
        //서버로 데이터 요청하고 응답받도록
        session.dataTask(with: url) { [weak self] data, response, error in
            let successRange = (200..<300) //성공한경우=
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            if let response = response as? HTTPURLResponse,successRange.contains(response.statusCode){
                guard let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data) else { return }
                DispatchQueue.main.async {
                    //날씨정보표시 스택뷰 보여주기
                    self?.weatherStackView.isHidden = false
                    self?.configureView(weatherInformation: weatherInformation)
                }
            }else {
                guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
                DispatchQueue.main.async {
                    self?.showAlert(message: errorMessage.message)
                }
            }
           
        }.resume()
        
    }
}

