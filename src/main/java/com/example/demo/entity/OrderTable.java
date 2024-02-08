package com.example.demo.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Data;

@Entity(name = "order_table")
@Data
public class OrderTable {
	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "id")
	private Long id;
	
	@Column(name = "order_id")
	private String orderId;
	
	@Column(name = "status")
	private String status;
	
	@Column(name = "payment_id")
	private String paymentId;
	
	@Column(name = "amount")
	private double amount;
	
	@Column(name = "signature_id")
	private String signatureId;
	

}
