package zentasktic_user

import (
	"strconv"
	"errors"
	"std"

	"gno.land/p/demo/avl"
)

type Payment struct {
    Id				string `json:"paymentId"`
    ObjectId 		string `json:"objectId"`
    ObjectType      string `json:"objectType"`
	Amount  		std.Coins `json:"paymentAmount"`
    Status			string `json:"paymentStatus"`            // invoices / paid, etc
}

var (
	Payments avl.Tree // p.Id -> p
)

func (p Payment) AddPayment() (err error) { 
	// implementation
	
	if Payments.Size() != 0 {
		existingP, exist := Payments.Get(p.Id)
		if exist {
			return ErrPaymentIdAlreadyExists
		}
	}
	Payments.Set(p.Id, p)
	return nil
}

func (p Payment) RemovePayment() (err error) { 
	// implementation
	existingP := Payment{}
	if Payments.Size() != 0 {
		existingP, exist := Payments.Get(p.Id)
		if !exist {
			return ErrPaymentIdNotFound
		}
	}

	_, removed := Payments.Remove(p.Id)
	if !removed {
		return ErrPaymentNotRemoved
	}
	return nil
}

func (p Payment) UpdatePayment() (err error) { 
	// implementation, get payment by Id and replace the object
	existingP := Payment{}
	if Payments.Size() != 0 {
		existingP, exist := Payments.Get(p.Id)
		if !exist {
			return ErrPaymentIdNotFound
		}
	}
	
	Payments.Set(p.Id, p)
	return nil
}

// getters

func GetPaymentByOjectId(objectId string, objectType string) (p Payment, err error) {
	// implementation
	payment := Payment{}

	// Iterate over the Payments AVL tree to see if we have a matching ObjectId.
	
	Payments.Iterate("", "", func(key string, value interface{}) bool {
		if paymentItem, ok := value.(Payment); ok {
			if paymentItem.ObjectId == objectId && paymentItem.ObjectType == objectType {
				payment = paymentItem
			}
		}
		return false // Continue iteration until all nodes have been visited.
	})

	return payment, nil
}

func GetAllPayments() (payments string, err error){
	// implementation
	var allPayments []*Payment

	// Iterate over the Payments AVL tree to collect all Payment objects.
	Payments.Iterate("", "", func(key string, value interface{}) bool {
		if payment, ok := value.(Payment); ok {
			allPayments = append(allPayments, &payment)
		}
		return false // Continue iteration until all nodes have been visited.
	})

	// Create a PaymentsObject with all collected payments.
	paymentsObject := &PaymentsObject{
		Payments: allPayments,
	}

	// Use the custom MarshalJSON method to marshal the rewards points into JSON.
	marshalledPayments, merr := paymentsObject.MarshalJSON()
	if merr != nil {
		return "", merr
	} 
	return string(marshalledPayments), nil
}

func GetTotalPayments() (totalAmount std.Coins, err error){
		total := std.Coins{}

		// Iterate over the Payments AVL tree 
		Payments.Iterate("", "", func(key string, value interface{}) bool {
				if paymentsItem, ok := value.(Payment); ok {
						total = total.Add(payment.Amount)
				}
				return false // Continue iteration until all nodes have been visited.
		})

		return total, nil
}
