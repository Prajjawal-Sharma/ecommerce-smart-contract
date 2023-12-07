//SPDX-License-Identifier:UNLICENSED 
pragma solidity >=0.5.0 <=0.9.0;

contract Ecommerce{

    struct Product{
        string title;
        string desc;
        address payable seller;
        uint productId;
        uint price;
        address buyer;
        bool delivered;
 }
 Product[] public products;
 uint counter=1;
 address payable manager;
 bool destroyed=false;

 modifier isDestroyed{
   require(!destroyed,"Contract has been destroyed");
   _;
 }
 
 constructor(){
   manager=payable(msg.sender);
   }

event registered(string title, uint productId,address seller);
event bought(uint productId, address buyer);
event delivered(uint productId);
 function registerProduct(string memory _title, string memory _desc, uint _price) public isDestroyed{
    require(_price>0,"Should be greater than 0");
    Product memory tempProduct;
    tempProduct.title=_title;
    tempProduct.desc=_desc;
    tempProduct.price=_price * 10 ** 18;
    tempProduct.seller= payable(msg.sender);
    tempProduct.productId=counter;
    products.push(tempProduct);
    counter++;
    emit registered(_title,tempProduct.productId,msg.sender);
 }
 function buy(uint _productId) payable public isDestroyed{
    require(products[_productId-1].price==msg.value,"Please pay the exact amount");
    require(products[_productId-1].seller!=msg.sender,"Seller cannot be the buyer");
    products[_productId-1].buyer=msg.sender;
    emit bought(_productId,msg.sender);
 }
 function delivery(uint _productId) public isDestroyed{
    require(products[_productId-1].buyer==msg.sender,"Only buyer can confirm the delivery");
    products[_productId-1].delivered=true;
    products[_productId-1].seller.transfer(products[_productId-1].price);
    emit delivered(_productId);
 }

function destroy() public isDestroyed{
   require(manager==msg.sender);
   manager.transfer(address(this).balance);
   destroyed=true;
}
}


