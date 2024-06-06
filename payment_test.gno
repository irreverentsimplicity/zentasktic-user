package zentasktic_user

import (
	"testing"
	"std"

    "gno.land/p/demo/avl"
	"gno.land/p/demo/zentasktic"
)

func Test_AddPayment(t *testing.T) {

    payment := Payment{Id: "1", ObjectId: "task1", ObjectType: "task", Amount: std.Coins{{Denom: "ugnot",  Amount: 100}}, Status: "Allocated",}

    // Test adding a payment successfully.
    err := payment.AddPayment()
    if err != nil {
        t.Errorf("Failed to add payment: %v", err)
    }

    // Test adding a duplicate payment.
    cerr := payment.AddPayment()
    if cerr != ErrPaymentIdAlreadyExists {
        t.Errorf("Expected ErrPaymentIdAlreadyExists, got %v", cerr)
    }
}

func Test_UpdatePayment(t *testing.T) {
	
	// Test editing an existing payment
	t.Run("Edit existing payment", func(t *testing.T) {
		updatedPayment := Payment{Id: "1", ObjectId: "task1", ObjectType: "task", Amount: std.Coins{{Denom: "ugnot",  Amount: 100}}, Status: "Disbursed",}
		err := updatedPayment.UpdatePayment()
		if err != nil {
			t.Errorf("expected no error, got %v", err)
		}

		// Verify the payment is updated
		editedPayment, exist := Payments.Get(updatedPayment.Id)
		if !exist {
			t.Errorf("expected payment to exist")
		}
		if editedPayment.(Payment).ObjectId != "task1" {
			t.Errorf("expected payment ObjectId to be 'task1', got %s", editedPayment.(Payment).ObjectId)
		}
	})

	// Test editing a non-existing payment
	t.Run("Edit non-existing payment", func(t *testing.T) {
		nonExistingP := Payment{Id: "999", ObjectId: "non-existing", ObjectType: "non-existing", Amount: std.Coins{{Denom: "non-existing",  Amount: 100}}, Status: "non-existing",}
		err := nonExistingP.UpdatePayment()
		if err != ErrPaymentIdNotFound {
			t.Errorf("expected error %v, got %v", ErrPaymentIdNotFound, err)
		}
	})
}

func Test_RemovePayment(t *testing.T) {
	
	pId := "2"
	payment := Payment{Id: pId, ObjectId: "project1", ObjectType: "project", Amount: std.Coins{{Denom: "ugnot",  Amount: 400}}, Status: "Allocated",}
	
	// Test removing a payment
	t.Run("Remove existing payment", func(t *testing.T) {
        // setting up the environment
        payment.AddPayment()

		err := payment.RemovePayment()
		if err != nil {
			t.Errorf("Failed to remove payment object: %v", err)
		}
	})

	// Test removing a payment that does not exist
	t.Run("Remove non-existing payment object", func(t *testing.T) {
		nonExistingP := Payment{Id: "999", ObjectId: "non-existing", ObjectType: "non-existing", Amount: std.Coins{{Denom: "non-existing",  Amount: 100}}, Status: "non-existing",}
		err := nonExistingP.RemovePayment()
		if err != ErrPaymentIdNotFound {
			t.Errorf("Expected error %v, got %v", ErrPaymentIdNotFound, err)
		}
	})
}

func Test_GetPaymentByOjectId(t *testing.T) {

	payment := Payment{Id: "1", ObjectId: "task1", ObjectType: "task", Amount: std.Coins{{Denom: "ugnot",  Amount: 100}}, Status: "Disbursed"}
	
	result, err := GetPaymentByOjectId("task1", "task")
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	if result.Id != payment.Id || result.Status != payment.Status {
		t.Errorf("Expected %v, got %v", payment, result)
	}

	// Test with non-existing data
	result, err = GetPaymentByOjectId("nonexistent", "task")
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	if (result != Payment{}) {
		t.Errorf("Expected empty Payment, got %v", result)
	}
}

func Test_GetAllPayments(t *testing.T){

	// Initialize test data
	payment1 := Payment{
		Id:         "1",
		ObjectId:   "task1",
		ObjectType: "task",
		Amount:     std.Coins{{Denom: "token", Amount: 20}},
		Status:     "Disbursed",
	}
	payment2 := Payment{
		Id:         "2",
		ObjectId:   "task2",
		ObjectType: "task",
		Amount:     std.Coins{{Denom: "token", Amount: 30}},
		Status:     "Assigned",
	}

	payment1.AddPayment()
	payment2.AddPayment()

	// Test the function
	result, err := GetAllPayments()
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	// Define the expected result
	expectedResult := `{"payments":[{"paymentId":"1","objectId":"task1","objectType":"task","paymentAmount":"100ugnot","paymentStatus":"Disbursed"},{"paymentId":"2","objectId":"task2","objectType":"task","paymentAmount":"30token","paymentStatus":"Assigned"}]}`
	if result != expectedResult {
		t.Errorf("Expected %v, got %v", expectedResult, result)
	}

	// Test with no rewards points
	payment1.RemovePayment()
	payment2.RemovePayment()
	
	result, err = GetAllPayments()
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}
	if result != `{"payments":[]}` {
		t.Errorf("Expected empty payments, got %v", result)
	}
}
/*
func Test_GetTotalRewardsPoints(t *testing.T) {
	
	// Add test data to the RewardsPoints tree.
	rewardsPoint1 := RewardsPoint{
		Id:         "1",
		ObjectId:   "task1",
		ObjectType: "task",
		Amount:     std.Coins{{Denom: "token", Amount: 10}},
		Status:     "Disbursed",
	}
	rewardsPoint2 := RewardsPoint{
		Id:         "2",
		ObjectId:   "task2",
		ObjectType: "task",
		Amount:     std.Coins{{Denom: "token", Amount: 20}},
		Status:     "Disbursed",
	}

	rewardsPoint1.AddRewardsPoints()
	rewardsPoint2.AddRewardsPoints()

	// Call the GetTotalRewardsPoints function.
	totalRewardsPoints, err := GetTotalRewardsPoints()
	if err != nil {
		t.Errorf("Failed to get total rewards points: %v", err)
	}

	// Check if the total rewards points is correct.
	expectedTotal := std.Coins{{Denom: "token", Amount: 30}}
	if !totalRewardsPoints.IsEqual(expectedTotal) {
		t.Errorf("Expected total rewards points to be %v, but got %v", totalRewardsPoints, expectedTotal)
	}
}

func (coins std.Coins) IsEqual(other std.Coins) bool {
	if len(coins) != len(other) {
		return false
	}
	for i := range coins {
		if coins[i].Denom != other[i].Denom || coins[i].Amount != other[i].Amount {
			return false
		}
	}
	return true
}*/