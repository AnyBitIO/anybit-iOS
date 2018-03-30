
/* Add by mengmeng.zhang */

/* Update SQL */

/* touch "`ruby -e "puts Time.now.strftime('%Y%m%d%H%M%S%3N').to_i"`"_CreateMyAwesomeTable.sql   生成该文件的命令 */

/* 钱包 */

CREATE TABLE IF NOT EXISTS T_DB_WALLET(
walletId text PRIMARY KEY NOT NULL,
walletName text,
walletUrl text,
mnemonicWords text,
seedKey text,
loginPsd text,
payPsd text,
needLoginPassword integer,
isDefault integer
);

/* 持有货币 */

CREATE TABLE IF NOT EXISTS T_DB_HOLD_COIN(
walletId text,
address text,
coinValue integer,
coinType text,
isDefault integer
);

/* 联系人 */

CREATE TABLE IF NOT EXISTS T_DB_CONTACTS(
walletId text,
nickName text,
coinType text,
address text
);

/* 交易记录 */

CREATE TABLE IF NOT EXISTS T_DB_TRANSACTION(
walletId text,
coinType text,
uniqueId text PRIMARY KEY NOT NULL,
txId text,
targetAddr text,
tranType text,
tranState text,
tranAmt text,
createTime text,
bak text
);
