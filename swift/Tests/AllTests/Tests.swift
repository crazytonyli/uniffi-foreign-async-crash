import Foundation
import RustLib
import Testing

final class AsyncTraitSwiftImpl: AsyncTrait {
    func asyncFn() async -> String {
        NSLog("Hello from Swift")
        return "Hello from Swift"
    }
}

@Test
func testForeign() async throws {
    let impl = AsyncTraitSwiftImpl()
    let app = App(foreign: impl)
    let result = await app.asyncFn()
    #expect(result == "Hello from Swift")
}
