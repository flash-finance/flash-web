

async function getAmount(index, account, tokenAddress, poolAddress) {
    let balanceAmount = '0';
    if (index == '0') {
        tronWeb.trx.getUnconfirmedBalance(account).then(result => {
            balanceAmount = result;
        }).catch(e=> {return});
    } else {
        let tokenObj = await tronWeb.contract().at(tokenAddress);
        balanceAmount = await tokenObj.balanceOf(account).call();
    }

    let poolObj = await tronWeb.contract().at(poolAddress);
    let depositedAmount = await poolObj.balanceOf(account).call();
    let harvestedAmount = await poolObj.earned(account).call();

    setAmount(index, balanceAmount, depositedAmount, harvestedAmount);
 }

async function getMineInfo(index, poolAddress, depositLpToken, mineLpToken) {
     let poolObj = await tronWeb.contract().at(poolAddress);
     let totalSupply = await poolObj.totalSupply().call();

     var account = 'TN39waq7kEvJBkwbDLovVi2G9zeKn4Y6ZQ';
     var usdtLpToken = 'TQn9Y2khEsLJW1ChVWFMSMeRDow5KcbLSE';

     let param1 = [{type:'uint256', value:'1000000'}]
     let res1 = await tronWeb.transactionBuilder.triggerConstantContract(usdtLpToken, 'getTokenToTrxInputPrice(uint256)', {}, param1, account);
     let value1 =  tronWeb.toDecimal('0x'+ res1.constant_result);

     let param2 = [{type:'uint256', value:value1}]
     let res2 = await tronWeb.transactionBuilder.triggerConstantContract(mineLpToken, 'getTrxToTokenInputPrice(uint256)', {}, param2, account);
     let value2 =  tronWeb.toDecimal('0x'+ res2.constant_result);

     if (index == '0') {
         setMineInfo(index, totalSupply, value1, value2);
     } else {
         let param3 = [{type:'uint256', value:value1}]
         let res3 = await tronWeb.transactionBuilder.triggerConstantContract(depositLpToken, 'getTrxToTokenInputPrice(uint256)', {}, param3, account);
         let value3 =  tronWeb.toDecimal('0x'+ res3.constant_result);
         setMineInfo(index, totalSupply, value3, value2);
     }

  }

async function allowance(tokenType, stakeAmount, account, tokenAddress, poolAddress) {
    let tokenObj = await tronWeb.contract().at(tokenAddress);
    let result = await tokenObj.allowance(account, poolAddress).call();
    setAllowance(tokenType, stakeAmount, tokenAddress, poolAddress, result);
}

async function approve(tokenType, stakeAmount, tokenAddress, poolAddress) {
    let tokenObj = await tronWeb.contract().at(tokenAddress);
    let result = await tokenObj.approve(poolAddress, '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff').send({
        feeLimit: 10000000
    });

    setStake(tokenType, stakeAmount, poolAddress);
}


async function stake(tokenType, amount, poolAddress) {
    let poolObj = await tronWeb.contract().at(poolAddress);
    let result = '';
    if (tokenType == '1') {
        result = await poolObj.stake().send({
         callValue: amount.toString(),
         feeLimit: 10000000
        });
    } else {
        result = await poolObj.stake(amount.toString()).send({
        feeLimit: 10000000
       });
    }

    console.log("stake result: " + result);
    setHash(1, result);
}


async function withdraw(amount, poolAddress) {
    let poolObj = await tronWeb.contract().at(poolAddress);
    let result = await poolObj.withdraw(amount.toString()).send({feeLimit: 10000000});

    console.log("withdraw result: " + result);
    setHash(2, result);
}

async function getReward(poolAddress) {
    let poolObj = await tronWeb.contract().at(poolAddress);
    let result = await poolObj.getReward().send({feeLimit: 10000000});

    console.log("getReward result: " + result);
    setHash(3, result);
}


