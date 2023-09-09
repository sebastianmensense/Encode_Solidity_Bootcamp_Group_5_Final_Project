// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import '@openzeppelin/contracts/access/Ownable.sol';
import './GroupFiveToken.sol';
import './GroupFiveCollection.sol';
import './interfaces/IGroupFiveToken.sol';
import './interfaces/IGroupFiveCollection.sol';

contract TokenSale is Ownable {
    uint256 public s_ratio;
    uint256 public s_price;
    IGroupFiveToken private immutable i_paymentToken;
    IGroupFiveCollection private immutable i_nftContract;

    constructor(uint256 _ratio, uint256 _price, address _paymentToken, address _nftContract) {
        s_ratio = _ratio;
        s_price = _price;
        i_paymentToken = IGroupFiveToken(_paymentToken); // this makes i_paymentToken an interface
        i_nftContract = IGroupFiveCollection(_nftContract); // this makes i_nftContract an interface
    }

    function buyTokens() external payable {
        uint256 amountToBeMinted = msg.value * s_ratio;
        i_paymentToken.mint(msg.sender, amountToBeMinted); // in GroupFiveToken msg.sender will be the TokenSale contract itself
    }

    function withdraw() external onlyOwner {
        // TODO
    }

    // Not needed???
    // function returnTokens(uint256 amount) external {
    //     // burn amount from sender
    //     i_paymentToken.burnFrom(msg.sender, amount);
    //     // transfer eth to sender
    //     payable(msg.sender).transfer(amount / ratio);
    // }

    function mintNft() external {
        // transfer payment of GFT from sender to TokenSale contract
        i_paymentToken.transferFrom(msg.sender, address(this), s_price);
        // mint nft
        i_nftContract.requestNft()
    }
}
