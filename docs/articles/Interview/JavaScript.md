---
sidebar: auto
---
# JavaScript 基础

## 变量类型

JavaScript 变量类型分为**值类型**，**引用类型**；值类型存放在栈中，引用类型存放在堆中。

其中值类型有 7 种：

- `String`
- `Boolean`
- `Number`
- `Null`
- `Undefined`
- `Symbol`
- `BigInt`

引用类型统称为`Object`，又可细分为以下 3 种：

- `Object`
- `Array`
- `Function`

### `typeof`

可以通过`typeof`关键字来判断一个变量的类型：

```js
typeof 'nick'                  // 'string'
typeof true                    // 'boolean'
typeof 123                     // 'number'
typeof undefined               // 'undefined'
typeof Symbol('symbol')        // 'symbol'
typeof BigInt('100')           // 'bigint'

typeof null                    // 'object'
typeof {}                      // 'object'
typeof []                      // 'object'
typeof function() {} // 'function'
```

::: warning 注意！
`typeof`对于值类型的`null`会判断为`object`，其他的则是原始类型；对引用类型的`function`会判断为`function`，其他的则都为`object`。
:::

## 类型转换

### 字符串拼接

当 JavaScript 中变量遇到字符串时，会自动转换为字符串：

```js
var str = 123 + '00'
var str1 = 'str' + true
var str2 = 'str' + 'ing'

console.log(str)    // '12300'
console.log(str1)   // 'strtrue'
console.log(str2)   // 'string'
```

### 相等和全等

使用相等符号`==`对变量进行比较时，会进行类型转换，然后确定两个变量是否相等。

在转换变量类型是，会按照以下规则进行转换：

- 如果任意变量为布尔值，则将其转换为数值再比较是否相等。false 转换为 0，true 转换为 1。
- 如果一个变量是字符串，另一个为数值，则尝试将字符串转换为数值，在比较是否相等。
- 如果一个变量为对象，另一个不是，则调用对象的 valueOf()方法获取其原始值，再根据前面的规则比较。
- `null`和`undefined`相等。
- `null`和`undefined`不能转换为其他类型在进行比较。
- NaN 与任何其他类型比较都返回 false，包括自己本身；不相等咋返回 true。
- 对象与对象比较，则会比较两个对象是否指向同一个对象的引用，不等则返回 false。

```js
null == undefined // true
false == 0        // true
true == 1         // true
true == '1'       // true
100 == '100'      // true
NaN == NaN        // false
NaN != NaN        // true
```

使用全等符号`===`进行比较时，变量不会进行类型转换；也就是说，数据类型不同，就返回 false。

```js
null === undefined  // false
null === null       // true
100 === '100'       // false
'nick' === 'nick'   // true
NaN === NaN         // false
```

::: warning 注意
NaN与任意值进行全等比较依然返回false，包括自身。
:::


### if条件，逻辑运算

使用到if语句以及逻辑运算时，条件内的值最终都会转换为布尔值。