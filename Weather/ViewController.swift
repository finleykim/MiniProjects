
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func tapFetchWeatherButton(_ sender: Any) {
        //버튼을 누르면 도시이름을 getCurrentWeather메서드의 파라미터에 전달해서 현재도시의 날씨정보를 가져오도록
        if let cityName = self.cityNameTextField.text { //텍스트필드의 텍스트 가져온다
            self.getCurrentWeather(cityName: cityName)
            self.view.endEditing(true)
        }
        
        
    }
    
    
    
    func getCurrentWeather(cityName: String){
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=5f2fcea356ec7f45c4f5f2d80f38c01a") else { return }
        let session = URLSession(configuration: .default)
        //서버로 데이터 요청하고 응답받도록
        session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data)
            debugPrint(weatherInformation)
        }.resume()
        
    }
}

