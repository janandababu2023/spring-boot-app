package anand.jaladanki;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class WelcomeRestController {

	@GetMapping
	public String getMsg() {
		return "Welcome to Anand Jaladanki Demo App";
	}
	
}
