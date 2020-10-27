
var flashSwapContract = 'TGS7NxoAQ44pQYCSAW3FPrVMhQ1TpdsTXg';

async function getTokenBalance(index, tokenType, tokenAddress, userAddress) {
    if (tokenType == '1') {
        tronWeb.trx.getUnconfirmedBalance(userAddress).then(result => {
        let balance = result;
        setBalance(index, tokenAddress, balance);
        });
    } else {
        let obj = await tronWeb.contract().at(flashSwapContract);
        let balance = await obj.getBalanceOfToken(tokenAddress, userAddress).call();
        setBalance(index, tokenAddress, balance);
    }

}

async function allowance(tokenType, tokenAddress, userAddress, tradeAmount) {
    let tokenObj = await tronWeb.contract().at(tokenAddress);
    let result = await tokenObj.allowance(userAddress, flashSwapContract).call();
    setAllowance(tokenType, tokenAddress, tradeAmount, result);
}

async function approve(tokenType, tokenAddress, tradeAmount) {
    let tokenObj = await tronWeb.contract().at(tokenAddress);
    let result = await tokenObj.approve(flashSwapContract, '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff').send({
        feeLimit: 10000000
    });

    setApprove(tokenType, tokenAddress, tradeAmount);
}

async function tokenToTrxSwap(swapToken, lpToken, tokensSold, minTrx, userAddress) {
    let obj = await tronWeb.contract().at(flashSwapContract);
    let result = await tokenObj.tokenToTrxSwap(swapToken, lpToken, tokensSold, minTrx, userAddress).send({
        feeLimit: 10000000
    });
}

async function trxToTokenSwap(swapToken, lpToken, minTokens, trxSold, userAddress) {
    let obj = await tronWeb.contract().at(flashSwapContract);
    let result = await tokenObj.trxToTokenSwap(swapToken, lpToken, minTokens, userAddress).send({
        callValue: trxSold.toString(),
        feeLimit: 10000000
    });
}

async function tokenToTokenSwap(swapToken, lpToken, tokensSold, minTokensBought, minTrxBought， userAddress, targetToken) {
    let obj = await tronWeb.contract().at(flashSwapContract);
    let result = await tokenObj.tokenToTokenSwap(swapToken, lpToken, tokensSold, minTokensBought, minTrxBought, userAddress, targetToken).send({
        feeLimit: 10000000
    });
}

