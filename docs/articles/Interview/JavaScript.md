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
typeof 'nick' // 'string'
typeof true // 'boolean'
typeof 123 // 'number'
typeof undefined // 'undefined'
typeof Symbol('symbol') // 'symbol'
typeof BigInt('100') // 'bigint'

typeof null // 'object'
typeof {} // 'object'
typeof [] // 'object'
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

console.log(str) // '12300'
console.log(str1) // 'strtrue'
console.log(str2) // 'string'
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
false == 0 // true
true == 1 // true
true == '1' // true
100 == '100' // true
NaN == NaN // false
NaN != NaN // true
```

使用全等符号`===`进行比较时，变量不会进行类型转换；也就是说，数据类型不同，就返回 false。

```js
null === undefined // false
null === null // true
100 === '100' // false
'nick' === 'nick' // true
NaN === NaN // false
```

::: warning 注意
NaN 与任意值进行全等比较依然返回 false，包括自身。
:::

### if 条件，逻辑运算

使用到 if 语句以及逻辑运算时，条件内的值最终都会转换为布尔值。

## 原型和原型链

### `prototype`

在 JavaScript 中，每个函数都会创建一个`prototype`属性，这个属性是一个对象，里面的属性与方法可以在实例中共享。`prototype`属性是通过调用构造函数穿件的对象的原型；也就是说，构造函数的原型就是`prototype`属性。

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

## 作用域与闭包

### 作用域

JavaScript 中有三种作用域：**全局作用域**，**函数作用域**，**块级作用域**。

#### 全局作用域

顾名思义，定义在全局中的变量所处的作用域环境就是全局作用域。全局作用域中的变量可以被任意访问。

```js
let name = 'nick'

function getName() {
  console.log(name)
}

getName() // nick
console.log(name) // nick
```

### 函数作用域

顾名思义，所处环境在函数中。函数作用域只能被当前作用域及内部作用域访问，无法被外部作用域访问。

```js
function foo() {
  var name = 'nick'
  console.log(name)
}
foo() // nick
console.log(name) // ReferenceError: name is not defined
```

### 块级作用域

包含在代码块`{}`中的变量，所处环境就为块级作用域。块级作用域只能被当前作用域内访问，不能被外部访问(var 除外)。

```js
{
  var name = 'nick'
  var age = 18

  let hobby = 'run'
  let eat = 'rice'

  console.log(name, age, bobby, eat) // 'nick' 18 run rice
}

console.log(name, age, hobby, eat) // ReferenceError: hobby is not defined
```

### 闭包

闭包是指能够访问自由变量的函数，而自由变量则是值在当前函数作用域中未定义，但是却被使用的变量。

```js
var name = 'nick'

function getName() {
  console.log(name)
}

getName() // 'nick'
```

对于自由变量的查找，是在函数定义的地方查找，而不是执行时。

```js
var name = 'nick'

function getName() {
  console.log(name)
}

function getOtherName() {
  var name = 'mike'
  getName()
}

getOtherName() // 'nick'
```

一般来说，有两种情况通常形成闭包：

- 函数作为返回值
- 函数作为参数

并且上面两种情况的函数都保留了对外部作用域中变量的引用，这就形成了闭包。

#### 闭包的使用场景

##### setTimeout

原生的`setTimeout`函数的第一个参数不能携带参数，可通过闭包实现。

```js
function getName(name) {
  return function() {
    console.log(name)
  }
}

let func = getName('nick')

setTimeout(func, 1000)
```

##### 封装私有变量

```js
function ownerVarible() {
  let count = 0

  return {
    increment: function() {
      return (count += 1)
    },
  }
}

let result = ownerVarible()

console.log(result.increment()) // 1
console.log(result.increment()) // 2
console.log(result.increment()) // 3
```

## JavaScript 创建对象方式

### 对象字面量

简单粗暴

```js
let person = {
  name: 'nick',
  age: 18,
}
```

### 工厂模式

工厂模式的主要工作原理是用函数来封装创建对象的细节，从而通过调用函数来 达到复用的目的。

```js
function createPerson(name, age) {
  let o = new Object()
  o.name = name
  o.age = age
  o.sayHi = function() {
    console.log(this.name, this.age)
  }

  return o
}

let p1 = createPerson('nick', 18)
let p2 = createPerson('mike', 20)

p1.sayHi() // 'nick' 18
p2.sayHi() // 'mike' 20
```

工厂模式能够解决创建多个类似对象的问题，但是没有解决对象标识问题，无法反应新创建的对象是什么类型。

### 构造函数模式

JavaScript 中每一个函数都可以作为构造函数，只要一个函数是通过 `new` 来调用的， 那么我们就可以把它称为构造函数。执行构造函数首先会创建一个对象，然后将对象的原型指向构造函数 的 `prototype` 属性，然后将执行上下文中的 `this` 指向这个对象，最后再执行整个函数，如果返回值不是 对象，则返回新建的对象。

```js
function Person(name, age) {
  this.name = name
  this.age = age
  this.sayHi = function() {
    console.log(this.name, this.age)
  }
}

let p1 = new Person('nick', 18)
let p2 = new Person('mike', 20)

p1.sayHi() // 'nick' 18
p2.sayHi() // 'mike' 20
```

构造函数模式和工厂模式大致相同，但是有以下几点不同：

::: warning
没有显示地创建对象。
属性和方法直接赋值给了`this`。
没有`return`。
:::

构造函数解决了对象类型识别的问题，但是内部定义的方法会在每个实例上都重新创建一遍，造成浪费。

### `Object.create`

该方法非常有用，因为它允许你为创建的对象选择一个原型对象，而不用定义构造函数，并且使用现有的对象来作为新创建对象的`__proto__`。

```js
const person = {
  name: 'nick',
  age: 18,
  sayHi: function() {
    console.log(this.name, this.age)
  },
}

let p1 = Object.create(person)

p1.name = 'mike'
p1.age = 20

p1.sayHi() // 'mike' 20
person.sayHi() // 'nick' 18

console.log(p1.__proto__ === person) // true
```

### 原型模式

每一个函数都有一个 `prototype` 属性，这个属性是一个对象，它包含了通过构造函数创建的所有实例都能共享的属性和方法。因此我们可以使用原型对象来添加公用属性和方法，从而实现代码的复用。

```js
function Person(name, age) {
  this.name = name
  this.age = age
}

Person.prototype.sayHi = function() {
  console.log(this.name, this.age)
}

let p1 = new Person('nick', 18)
let p2 = new Person('mike', 20)

p1.sayHi() // 'nick' 18
p2.sayHi() // 'mike' 20
```

原型模式中，动态属性可以放在构造函数内，通过参数获取；共用的方法可以放在原型上，在实例间共享，重复使用。

但是原型模式的问题也在于所有属性都能够在实例之间共享。这似乎没什么问题，但是原型中若是有引用类型的属性，则会造成混乱。
