// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Mint is ERC721, ERC721Enumerable, ERC721Pausable, Ownable {
    uint256 private _nextTokenId;
    address public usdcTokenAddress; // Address of the USDC token contract

    constructor(address initialOwner, address _usdcTokenAddress)
        ERC721("HackweekMint", "HWM")
        Ownable(initialOwner)
    {
        usdcTokenAddress = _usdcTokenAddress;
    }

    // Add the mintInUSDC function
    function mintInUSDC() external {
        IERC20 erc20Token = IERC20(usdcTokenAddress);
        address sender = msg.sender;
        uint256 cost = 10000;
        uint256 allowance = erc20Token.allowance(sender, address(this));
        uint256 balance = erc20Token.balanceOf(sender);
        
        require(allowance >= cost, "Allowance not set or insufficient");
        require(balance >= cost, "Sender balance of payment token is insufficient");

        // Transfer 10,000 tokens from the sender to the seller's address
        require(erc20Token.transferFrom(sender, owner(), cost), "Transfer failed");

        // Mint the NFT to the caller
        safeMint(sender);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(address to) public {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
