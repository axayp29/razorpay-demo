package com.example.demo.entity;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface OrderRepository extends JpaRepository<OrderTable, Long> {
	
	OrderTable findByOrderId(String orderId);

}
