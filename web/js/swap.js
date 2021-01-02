
var flashSwapContract = 'TGS7NxoAQ44pQYCSAW3FPrVMhQ1TpdsTXg';

async function getTokenBalance(tokenType, tokenAddress, userAddress) {
    if (tokenType == '1') {
        tronWeb.trx.getUnconfirmedBalance(userAddress).then(result => {
        let balance = result;
        setBalance(tokenAddress, balance);
        });
    } else {
        let obj = await tronWeb.contract().at(tokenAddress);
        let balance = await obj.balanceOf(userAddress).call();
        setBalance(tokenAddress, balance);
    }
}

async function allowance(lpTokenAddress, swapTokenType, baseTokenType, swapTokenAddress, baseTokenAddress, userAddress, swapTradeValue, baseTradeValue) {
    let code = 0;
    let obj = await tronWeb.contract().at(swapTokenAddress);
    let result = await obj.allowance(userAddress, flashSwapContract).call().catch(e => {
        console.log('allowance error:' + JSON.stringify(e));
        setError(JSON.stringify(e));
        code = 1;
     });

     if (code == 1) {
        return;
     }
    //  USDT BTC
    if (swapTokenAddress == 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t' || swapTokenAddress == 'TN3W4H6rK2ce4vX9YnFQHwKENnHjoxb3m9' || swapTokenAddress == 'THb4CqiFdwNHsWsQCs4JhzwjMWys4aqCbF') {
        result = tronWeb.toDecimal(result.remaining._hex);
    }
    // USDJ
    else if (swapTokenAddress == 'TMwFHYXLJaRUPeW6421aqXL4ZEzPRFGkGT') {
        result = tronWeb.toDecimal(result._hex);
    }

    console.log('allowance result: ' + JSON.stringify(result));
    setAllowance(lpTokenAddress, swapTokenType, baseTokenType, swapTokenAddress, baseTokenAddress, swapTradeValue, baseTradeValue, result);
}


async function approve(lpTokenAddress, swapTokenType, baseTokenType, swapTokenAddress, baseTokenAddress, swapTradeValue, baseTradeValue) {
    let code = 0;
    let obj = await tronWeb.contract().at(swapTokenAddress);
    let result = await obj.approve(flashSwapContract, '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff').send({
        feeLimit: 10000000
    }).catch(e => {
        console.log('approve error:' + JSON.stringify(e));
        setError(JSON.stringify(e));
        code = 1;
     });
     if (code == 1) {
        return;
     }
    setApprove(lpTokenAddress, swapTokenType, baseTokenType, swapTokenAddress, baseTokenAddress, swapTradeValue, baseTradeValue);
}

async function trxToTokenSwap(swapToken, lpToken, minTokens, trxSold, userAddress) {
    let code = 0;
    let obj = await tronWeb.contract().at(flashSwapContract);
    let result = await obj.trxToTokenSwap(swapToken, lpToken, minTokens.toString(), userAddress).send({
        callValue: trxSold.toString(),
        feeLimit: 10000000
    }).catch(e => {
       console.log('trxToTokenSwap error:' + JSON.stringify(e));
       setError(JSON.stringify(e));
       code = 1;
    });
    if (code == 1) {
        return;
    }
    console.log('trxToTokenSwap result:' + result);
    setTrxToTokenSwap(swapToken, result);
}

async function tokenToTrxSwap(swapToken, lpToken, tokensSold, minTrx, userAddress) {
    let code = 0;
    let obj = await tronWeb.contract().at(flashSwapContract);
    let result = await obj.tokenToTrxSwap(swapToken, lpToken, tokensSold.toString(), minTrx.toString(), userAddress).send({
        feeLimit: 10000000
    }).catch(e => {
       console.log('tokenToTrxSwap error:' + JSON.stringify(e));
       setError(JSON.stringify(e));
       code = 1;
    });
    if (code == 1) {
        return;
    }
    console.log('tokenToTrxSwap result:' + result);
    setTokenToTrxSwap(swapToken, result);
}

async function tokenToTokenSwap(swapToken, lpToken, tokensSold, minTokensBought, minTrxBought, userAddress, targetToken) {
    let code = 0;
    let obj = await tronWeb.contract().at(flashSwapContract);
    let result = await obj.tokenToTokenSwap(swapToken, lpToken, tokensSold.toString(), minTokensBought.toString(), minTrxBought.toString(), userAddress, targetToken).send({
        feeLimit: 10000000
    }).catch(e => {
        console.log('tokenToTokenSwap error:' + JSON.stringify(e));
        setError(JSON.stringify(e));
        code = 1;
    });

    if (code == 1) {
        return;
    }
    console.log('tokenToTokenSwap result:' + result);
    setTokenToTokenSwap(swapToken, targetToken, result);
}

