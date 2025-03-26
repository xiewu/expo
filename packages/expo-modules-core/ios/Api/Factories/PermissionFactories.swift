public func Permission(
  _ name: String,
  @PermissionDefinitionBuilder _ elements: @escaping () -> [AnyPermissionDefinitionElement]
) -> PermissionDefinition {
  return PermissionDefinition(
    name,
    elements: elements()
  )
}


public func Checker<R>(
  @_implicitSelfCapture _ closure: @escaping () throws -> R
) -> PermissionCheckerDefinition<(), Void, R> {
  return PermissionCheckerDefinition(
    firstArgType: Void.self,
    dynamicArgumentTypes: [],
    closure
  )
}

public func Requester<R>(
  @_implicitSelfCapture _ closure: @escaping () async throws -> R
) -> PermissionRequesterDefinition<(), Void, R> {
  return PermissionRequesterDefinition(
    firstArgType: Void.self,
    dynamicArgumentTypes: [],
    closure
  )
}
