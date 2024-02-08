package com.example.demo.controller;

import java.util.Map;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.entity.OrderRepository;
import com.example.demo.entity.OrderTable;
import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import com.razorpay.RazorpayException;

@Controller
public class DemoController {

	@Autowired
	private OrderRepository orderRepository;

	@Value("${razorpay.api-key}")
	String apiKey;

	@Value("${razorpay.secret-key}")
	String secretKey;

	@GetMapping("/index")
	public String getIndexPage() {

		return "index";
	}

	@PostMapping("/user/create_order")
	@ResponseBody
	public String createOrder(@RequestBody Map<String, Object> map) throws RazorpayException {


		int amount = Integer.parseInt(map.get("amount").toString());

		RazorpayClient client = new RazorpayClient(apiKey, secretKey);

		JSONObject ob = new JSONObject();
		ob.put("amount", amount * 100);
		ob.put("currency", "INR");
		ob.put("receipt", "txn_12345");

		Order order = client.Orders.create(ob);

		OrderTable orderTable = new OrderTable();
		orderTable.setAmount(amount);
		orderTable.setOrderId(order.get("id").toString());
		orderTable.setStatus(order.get("status").toString());

		orderRepository.save(orderTable);

		System.err.println(order);
		return order.toString();
	}

	@PostMapping("/order/save")
	@ResponseBody
	public String saveOrder(@RequestBody Map<String, Object> map) throws RazorpayException {

		String paymentId = map.get("razorpay_payment_id").toString();
		String orderId = map.get("razorpay_order_id").toString();
		String signatureId = map.get("razorpay_signature").toString();

		OrderTable order = orderRepository.findByOrderId(orderId);

		order.setPaymentId(paymentId);
		order.setSignatureId(signatureId);
		if (!paymentId.isEmpty() && !signatureId.isEmpty()) {
			order.setStatus("PAID");
		}

		orderRepository.save(order);

		return "success";
	}

}
