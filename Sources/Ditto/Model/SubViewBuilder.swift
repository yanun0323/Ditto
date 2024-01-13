import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@resultBuilder public struct SubViewBuilder {

    /// Builds an expression within the builder.
    @MainActor public static func buildExpression<Content>(_ content: Content) -> Content where Content : View {
        return content
    }

    /// Builds an empty view from a block containing no statements.
    @MainActor public static func buildBlock() -> EmptyView {
        return EmptyView()
    }

    /// Passes a single view written as a child view through unmodified.
    ///
    /// An example of a single view written as a child view is
    /// `{ Text("Hello") }`.
    @MainActor public static func buildBlock<Content>(_ content: Content) -> Content where Content : View {
        return content
    }

    @MainActor public static func buildBlock<each Content>(_ content: repeat each Content) -> TupleView<(repeat each Content)> where repeat each Content : View {
        return TupleView<(repeat (each Content))>((repeat (each content)))
    }
    
    /// Produces an optional view for conditional statements in multi-statement
    /// closures that's only visible when the condition evaluates to true.
    @MainActor public static func buildIf<Content>(_ content: Content?) -> Content? where Content : View {
        return content
    }

    /// Produces content for a conditional statement in a multi-statement closure
    /// when the condition is true.
    @MainActor public static func buildEither<TrueContent, FalseContent>(first: TrueContent) -> _ConditionalContent<TrueContent, FalseContent> where TrueContent : View, FalseContent : View {
        return buildEitherContent(first: first)
    }

    /// Produces content for a conditional statement in a multi-statement closure
    /// when the condition is false.
    @MainActor public static func buildEither<TrueContent, FalseContent>(second: FalseContent) -> _ConditionalContent<TrueContent, FalseContent> where TrueContent : View, FalseContent : View {
        return buildEitherContent(second: second)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct _ConditionalContent<TrueContent, FalseContent>: View {
    public var body: Never { fatalError() }
    let storage: Storage
    // Use enumeration to lock type information
    enum Storage {
        case trueContent(TrueContent)
        case falseContent(FalseContent)
    }

    init(storage: Storage) {
        self.storage = storage
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public func buildEitherContent<TrueContent, FalseContent>(first content: TrueContent) -> _ConditionalContent<TrueContent, FalseContent> where TrueContent: View, FalseContent: View {
    .init(storage: .trueContent(content))
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public func buildEitherContent<TrueContent, FalseContent>(second content: FalseContent) -> _ConditionalContent<TrueContent, FalseContent> where TrueContent: View, FalseContent: View {
    .init(storage: .falseContent(content))
}
