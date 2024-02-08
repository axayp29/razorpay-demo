<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Green Apex</title>
<link rel="shortcut icon" type="image"
	href="${pageContext.request.contextPath}/img/green-apex.jpg">
<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
	rel="stylesheet">

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"
	integrity="sha256-4+XzXTPc5nC+gNzCM+ebE37OWqsGh0tq7qL7O3AFoE"
	crossorigin="anonymous"></script>

<!-- Bootstrap JS, Popper.js, and Bootstrap Bundle -->
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-pzjw8V+9DqOn+6E6HTLG8S/Z9fNfEXAF5TcMoId6jS"
	crossorigin="anonymous"></script>

<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>

<style>
        /* Container styles */
        .center-container {
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100px; /* Adjust as needed */
            margin-top: 10px;
        }

        /* Image styles */
        .center-image {
            max-width: 100%;
            max-height: 100%;
        }
    </style>

</head>
<body>

	<div class="container mt-5">
		<div class="row justify-content-center">
			<div class="col-md-6">
				<div class="card">
					<div class="card-header">Pay To Green Apex</div>
					<div class="center-container">
						<img alt="Green-apex"
							src="${pageContext.request.contextPath}/img/green-apex.jpg"
							class="center-image" height="100px" width="100px">
					</div>
					<div class="card-body">
						<form id="paymentForm">
							<div class="mb-3">
								<label for="amount" class="form-label">Amount</label> <input
									type="number" class="form-control" id="amount" name="amount"
									placeholder="Enter amount" required>
							</div>
							<div style="text-align: center;">
							<button type="button" class="btn btn-primary"
								onclick="paymentStart()" id="payButton" >Pay Now</button>
								</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>



<script type="text/javascript">



const paymentStart=()=>{
	
	var amount = $('#amount').val();
	
	$.ajax({
		url : '/user/create_order',
		data :JSON.stringify({amount : amount}),
		contentType : 'application/json',
		type : 'POST',
		dataType :'json',
		success : function(response){
			console.log(response);
			if(response.status == 'created')
				{
				//open payment from
				 var options = {
					        key: 'rzp_test_mpyJdarf2qjlmh',
					        amount: response.amount, 
					        currency: 'INR',
					        name: 'Green Apex Technolabs',
					        description: 'IT Company',
					        order_id: response.id,
					        image : 'https://images.softwaresuggest.com/company_logo/greenapexsolutionslimited-20240109145054.png',
					        handler: function (response) {
					        	
					            // Handle the success callback (update your server with payment details)
					            var order_id = response.razorpay_order_id;
                				var payment_id = response.razorpay_payment_id;
              					  var signature = response.razorpay_signature;

              					  ajaxfordataSave(response);
               				
					         // Display a SweetAlert for successful payment
              					sweetalertSuccess();
					         
					   
				              
					        },
					       /*  prefill: {
					            name: 'Customer Name',
					            email: 'customer@example.com',
					            contact: 'customer_phone_number',
					        }, */
					        notes: {
					            address: 'Green Apex Corporate Office',
					        },
					        
					        theme :  { color : '#50C878'},
					    };

					    var rzp = new Razorpay(options);
					    
					   rzp.on("paymenr.failed",function(response){
						   
						   showErrorAlert(response)
						   
					   });
					    
					    rzp.open();
				
				}
		},
		error : function(error){
			alert('something went wrong');
		}
	})
	
};

</script>

<script type="text/javascript">

function sweetalertSuccess(){
	
	  Swal.fire({
          icon: 'success',
          title: 'Payment Successful!',
          text: 'Your Payment is Successfull',
          confirmButtonText: 'OK',
      });
	
}


function showErrorAlert(response) {
    Swal.fire({
        icon: 'error',
        title: 'Payment Failed',
        text: 'Error: ' + response.error.description,
        confirmButtonText: 'OK',
    });
}

function ajaxfordataSave(response){
	
	console.log("called");
	
	 $.ajax({
		url : '/order/save',
		data :JSON.stringify({razorpay_payment_id : response.razorpay_payment_id
			,razorpay_order_id : response.razorpay_order_id
			,razorpay_signature : response.razorpay_signature}),
		contentType : 'application/json',
		type : 'POST',
		dataType :'json',
		success : function(response){
		
			console.log('Data Saved');
		}
	}); 
	
	
}

</script>

</html>