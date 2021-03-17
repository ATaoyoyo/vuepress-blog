---
sidebar: auto
---
# JavaScript

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


## 原型和原型链

### `prototype`

在JavaScript中，每个函数都会创建一个`prototype`属性，这个属性是一个对象，里面的属性与方法可以在实例中共享。`prototype`属性是通过调用构造函数穿件的对象的原型；也就是说，构造函数的原型就是`prototype`属性。

```js
function Person() {}

Person.prototype.name = 'nick'
Person.prototype.age = 18
Person.prototype.sayHi = function() {
  console.log(this.name, this.age)
}

let p1 = new Person()
p1.sayHi() // 'nick' 18
console.log(p1.name, p1.age) // 'nick'  18

console.log(Person.prototype) // Person { name: 'nick', age: 18, sayHi: [Function (anonymous)] }
```

### `__proto__`

实例对象查找属性时会从自身开始查找，如果有，则直接使用；如果没有，则会通过`__proto__`找到构造对象的原型中查找。

```js
function Person() {}

Person.prototype.name = 'nick'

let p1 = new Person()
p1.age = 18

console.log(p1.name, p1.age) // nick 18
console.log(p1.__proto__ === Person.prototype) // true
```

### `constructor`

构造函数的`prototype`和该构造函数的实例对象的`__proto__`都有一个`constructor`属性，默认都指向该构造函数本身。

```js
function Person() {}

let p1 = new Person()

console.log(Person.prototype.constructor === p1.__proto__.constructor) // true
```

### 构造函数的`prototype`的`__proto__`

构造函数的`prototype`也有`__proto__`属性，普通构造函数原型上的`__proto__`指向特殊构造函数`Object`的原型；而`Object`原型上的`__proto__`指向`null`。

也就是说，实例对象查找属性时会从自身开始查找，如果没有，则会通过`__proto__`一直查找原型中有没有需要的属性，有的话就取出，没有的话，就一直到`null`，返回`undefined`。

```js
function Person() {}
Person.prototype.name = 'nick'

let p1 = new Person()
p1.age = 18

console.log(p1.name, p1.age, p1.hobby) // 'nick' 18 undefined
```

### 构造函数的`__proto__`

所有构造函数都是内置构造函数`Function`的实例，所以构造函数的`__proto__`都指向`Function`的原型，包括`Function`自身的`__proto__`，也是指向自己的原型。

```js
function Person() {}

console.log(Person.prototype.__proto__ === Object.prototype) // true
console.log(Person.__proto__ === Function.prototype) // true
console.log(Function.__proto__ === Function.prototype) // true
```

### `instanceof`基于原型链实现

`instanceof`运算符用于检测构造函数的 `prototype` 属性是否出现在某个实例对象的原型链上。也可以理解为构造函数的`prototype`属性是否与实例的`__proto__`相等。

::: tip 
实例对象的`__proto__`指向创建它的构造函数的原型。
构造函数原型的`__proto__`指向`Object`的原型。
构造函数都是`Function`的实例。
:::
