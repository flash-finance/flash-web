
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

async function tokenToTrxSwap(swapToken, lpToken, tokensSold, minTrx, user) {
    let obj = await tronWeb.contract().at(flashSwapContract);
    let result = await tokenObj.tokenToTrxSwap(swapToken, lpToken, tokensSold, minTrx, user).send({
        feeLimit: 10000000
    });
}

async function trxToTokenSwap(swapToken, lpToken, minTokens, trxSold, user) {
    let obj = await tronWeb.contract().at(flashSwapContract);
    let result = await tokenObj.trxToTokenSwap(swapToken, lpToken, minTokens, user).send({
        callValue: trxSold.toString(),
        feeLimit: 10000000
    });
}

async function tokenToTokenSwap(swapToken, lpToken, tokensSold, minTokensBought, minTrxBought， user, targetToken) {
    let obj = await tronWeb.contract().at(flashSwapContract);
    let result = await tokenObj.tokenToTokenSwap(swapToken, lpToken, tokensSold, minTokensBought, minTrxBought, user, targetToken).send({
        feeLimit: 10000000
    });
}

