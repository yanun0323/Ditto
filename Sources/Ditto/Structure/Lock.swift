import SwiftUI

extension DispatchSemaphore {
    public func tryWait(after timeout: TimeInterval = 0) -> Bool {
        return self.wait(timeout: .now()+timeout) == .success
    }
}

public class Lock {
    private let _innerLock = DispatchSemaphore(value: 1)
    private let _lock = DispatchSemaphore(value: 1)
    
    public func lock() {
        _innerLock.wait()
        defer { _innerLock.signal() }
        
        _lock.wait()
    }
    
    public func unlock() {
        _innerLock.wait()
        defer { _innerLock.signal() }
        
        if !_lock.tryWait() {
            _lock.signal()
        }
    }
    
    public func tryLock() -> Bool {
        _innerLock.wait()
        defer { _innerLock.signal() }
        
        return _lock.tryWait()
    }
    
    func isLock() -> Bool {
        _innerLock.wait()
        defer { _innerLock.signal() }
        
        if _lock.tryWait() {
            _lock.signal()
            return false
        }
        
        return true
    }
}


class ReadWriteLock {
    private var _lock = pthread_rwlock_t()

    init() {
        pthread_rwlock_init(&_lock, nil)
    }

    deinit {
        pthread_rwlock_destroy(&_lock)
    }
    
    func rLock() {
        pthread_rwlock_rdlock(&_lock)
    }
    
    func rUnlock() {
        pthread_rwlock_unlock(&_lock)
    }
    
    func lock() {
        pthread_rwlock_wrlock(&_lock)
    }
    
    func unlock() {
        pthread_rwlock_unlock(&_lock)
    }

    func read<T>(_ closure: () -> T) -> T {
        pthread_rwlock_rdlock(&_lock)
        defer { pthread_rwlock_unlock(&_lock) }
        return closure()
    }

    func write(_ closure: () -> Void) {
        defer { pthread_rwlock_unlock(&_lock) }
        closure()
    }
}

#if DEBUG
struct LockView: View {
    var l: Lock
    var body: some View {
        VStack {
            Button("lock") {
                l.lock()
            }
            
            Button("unlock") {
                l.unlock()
            }
            
            Button("try lock") {
                print("try lock limited lock", l.tryLock())
            }
        }
    }
}

#Preview {
    var l = Lock()
    
    return VStack {
        LockView(l: l)
        LockView(l: l)
    }
}
#endif
