package main

import (
	"crypto/rand"
	_ "crypto/rand"
	"crypto/rsa"
	"crypto/x509"
	"encoding/pem"
	"fmt"
	"github.com/golang-jwt/jwt"
	"log"
	_ "reflect"
	"time"
)

// var hmacSampleSecret []byte
func exportPrivateKeyAsPEMStr(privateKey *rsa.PrivateKey) string {
	privateKeyPem := string(pem.EncodeToMemory(
		&pem.Block{
			Type:  "RSA PRIVATE KEY",
			Bytes: x509.MarshalPKCS1PrivateKey(privateKey),
		},
	))
	return privateKeyPem
}

func exportPEMStrToPrivateKey(privateKeyPem string) *rsa.PrivateKey {
	block, _ := pem.Decode([]byte(privateKeyPem))
	key, _ := x509.ParsePKCS1PrivateKey(block.Bytes)
	return key
}

func main() {
	fmt.Println(rand.Reader)
	privateKey, err := rsa.GenerateKey(rand.Reader, 2048)
	publicKey := privateKey.Public()
	privateKeyPemStr := exportPrivateKeyAsPEMStr(privateKey)
	privateKey = exportPEMStrToPrivateKey(privateKeyPemStr)
	token := jwt.New(jwt.SigningMethodRS256)
	claims := token.Claims.(jwt.MapClaims)
	claims["foo"] = "bar"
	claims["nbf"] = time.Date(2015, 10, 10, 12, 0, 0, 0, time.UTC).Unix()
	if err != nil {
		log.Fatal(err)
	}
	tokenString, err := token.SignedString(privateKey)
	if err != nil {
		log.Fatal(err)
	}
	token, err = jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		fmt.Println(token)
		if _, ok := token.Method.(*jwt.SigningMethodRSA); !ok {
			return nil, fmt.Errorf("Unexpected signing method: %v", token.Header["alg"])
		}
		return publicKey, nil
	})
	if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
		fmt.Println(claims["foo"], claims["nbf"])
		fmt.Println("SUCCESS")
	} else {
		fmt.Println(err)
	}
}
