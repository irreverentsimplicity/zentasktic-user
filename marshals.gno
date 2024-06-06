package zentasktic_user

import (
	"strconv"
	"bytes"
	"errors"
	"std"
)

type UsersObject struct {
	Users []User
}

type PaymentsObject struct {
	Payments	[]*Payment
}

func (u User) MarshalJSON() ([]byte, error) {

	var b bytes.Buffer
	
	b.WriteByte('{')

	b.WriteString(`"usereId":"`)
	b.WriteString(u.Id)
	b.WriteString(`",`)

	b.WriteString(`"userName":"`)
	b.WriteString(u.Name)
	b.WriteString(`",`)

	b.WriteString(`"userAddress":"`)
	b.WriteString(string(u.Address))
	b.WriteString(`"`)

	b.WriteByte('}')

	return b.Bytes(), nil
}

func (uo UsersObject) MarshalJSON() ([]byte, error) {
	var b bytes.Buffer

	b.WriteString(`{"users":[`)
	
	for i, user := range uo.Users {
		if i > 0 {
			b.WriteString(`,`)
		}
		userJSON, cerr := user.MarshalJSON()
		if cerr == nil {
			b.WriteString(string(userJSON))
		}
	}

	b.WriteString(`]}`)

	return b.Bytes(), nil
}

func (p Payment) MarshalJSON() ([]byte, error) {

	var b bytes.Buffer
	
	b.WriteByte('{')

	b.WriteString(`"paymentId":"`)
	b.WriteString(p.Id)
	b.WriteString(`",`)

	b.WriteString(`"objectId":"`)
	b.WriteString(p.ObjectId)
	b.WriteString(`",`)

	b.WriteString(`"objectType":"`)
	b.WriteString(p.ObjectType)
	b.WriteString(`",`)

	b.WriteString(`"paymentAmount":"`)
	b.WriteString(string(p.Amount.String()))
	b.WriteString(`",`)

	b.WriteString(`"paymentStatus":"`)
	b.WriteString(p.Status)
	b.WriteString(`"`)

	b.WriteByte('}')

	return b.Bytes(), nil
}

func (po PaymentsObject) MarshalJSON() ([]byte, error) {
	var b bytes.Buffer

	b.WriteString(`{"payments":[`)
	
	for i, payment := range po.Payments {
		if i > 0 {
			b.WriteString(`,`)
		}
		paymentsJSON, cerr := payment.MarshalJSON()
		if cerr == nil {
			b.WriteString(string(paymentsJSON))
		}
	}

	b.WriteString(`]}`)

	return b.Bytes(), nil
}