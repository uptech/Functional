import Foundation

// ForwardApplication - pipe forward operator
//
// This is an operator to apply a function
//
// 2 |> incr
// 2 |> incr |> square

precedencegroup ForwardApplication {
    associativity: left
}

infix operator |>: ForwardApplication

public func |> <A, B>(a: A, f: (A) -> B) -> B {
    return f(a)
}

public func |> <A>(a: inout A, f: (inout A) -> Void) -> Void {
    f(&a)
}

// ForwardComposition - right arrow operator
//
// This is an operator to compose multiple functions together
//
// incr >>> square
// square >>> incr
// (incr >>> square)(2)
// 2 |> incr >>> square

precedencegroup ForwardComposition {
    associativity: left
    higherThan: ForwardApplication, EffectfulComposition
}

infix operator >>>: ForwardComposition

public func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> ((A) -> C) {
    return { a in
        g(f(a))
    }
}

// EffectfulComposition - fish operator
//
//
// 2
// |> computeAndPrint
// >=> computeAndPrint
// >=> computeAndPrint

precedencegroup EffectfulComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator >=>: EffectfulComposition

public func >=> <A, B, C>(
    _ f: @escaping (A) -> (B, [String]),
    _ g: @escaping (B) -> (C, [String])
    ) -> ((A) -> (C, [String]   )) {

    return { a in
        let (b, logs) = f(a)
        let (c, moreLogs) = g(b)
        return (c, logs + moreLogs)
    }
}

public func >=> <A, B, C>(
    _ f: @escaping (A) -> B?,
    _ g: @escaping (B) -> C?
    ) -> ((A) -> C?) {

    return { a in
        fatalError()
//        let (b, logs) = f(a)
//        let (c, moreLogs) = g(b)
//        return (c, logs + moreLogs)
    }
}

public func >=> <A, B, C>(
    _ f: @escaping (A) -> [B],
    _ g: @escaping (B) -> [C]
    ) -> ((A) -> [C]) {

    return { a in
        fatalError()
        //        let (b, logs) = f(a)
        //        let (c, moreLogs) = g(b)
        //        return (c, logs + moreLogs)
    }
}

//func >=> <A, B, C>(
//    _ f: @escaping (A) -> Promise<B>,
//    _ g: @escaping (B) -> Promise<C>
//    ) -> ((A) -> Promise<C>) {
//
//    return { a in
//        fatalError()
//        //        let (b, logs) = f(a)
//        //        let (c, moreLogs) = g(b)
//        //        return (c, logs + moreLogs)
//    }
//}


// SingleTypeComposition - diamond operator

precedencegroup SingleTypeComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator <>: SingleTypeComposition

public func <> <A>(f: @escaping (A) -> A, g: @escaping (A) -> A) -> (A) -> A {
    return { a in
        f(g(a))
    }
}

public func <> <A>(f: @escaping (inout A) -> Void, g: @escaping (inout A) -> Void) -> (inout A) -> Void {
    return { a in
        f(&a)
        g(&a)
    }
}

public func <> <A: AnyObject>(f: @escaping (A) -> Void, g: @escaping (A) -> Void) -> (A) -> Void {
    return { a in
        f(a)
        g(a)
    }
}

// Curry

public func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { a in { b in f(a, b) } }
}

public func curry<A, B, C, D>(_ f: @escaping (A, B, C) -> D) -> (A) -> (B) -> (C) -> D {
    return { a in { b in { c in f(a, b, c) } } }
}

// Flip

public func flip<A, B, C>(_ f: @escaping (A) -> (B) -> C) -> (B) -> (A) -> C {
    return { b in { a in f(a)(b) }}
}

public func flip<A, B, C, D>(_ f: @escaping (A) -> (B) -> (C) -> D) -> (C) -> (B) -> (A) -> D {
    return { c in { b in { a in f(a)(b)(c) } } }
}

// Zurry

public func zurry<A>(_ f: () -> A) -> A {
    return f()
}

// Map - free form

public func map<A, B>(_ f: @escaping (A) -> B) -> ([A]) -> ([B]) {
    return { $0.map(f) }
}

// Filter - free form

public func filter<A>(_ p: @escaping (A) -> Bool) -> ([A]) -> [A] {
    return { $0.filter(p) }
}


// Logical Function Composition

public func && <A>(
    f: @escaping (A) -> Bool,
    g: @escaping (A) -> Bool) -> ((A) -> Bool) {
    return { a in
        return f(a) && g(a)
    }
}

public func || <A>(
    f: @escaping (A) -> Bool,
    g: @escaping (A) -> Bool) -> ((A) -> Bool) {
    return { a in
        return f(a) || g(a)
    }
}
