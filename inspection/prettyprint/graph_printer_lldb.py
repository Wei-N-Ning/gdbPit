
import lldb


# source
# https://github.com/llvm-mirror/lldb/blob/master/examples/python/sbvalue.py
# also:
# WHERE IS LLDB's STL PRETTY PRINTER????
# http://llvm.org/svn/llvm-project/lldb/trunk/examples/synthetic/libcxx.py


class Value(object):
    """
    A class that wraps an lldb.SBValue object and returns an object that
    can be used as an object with attributes:

    argv = a.value(lldb.frame.FindVariable('argv'))
    argv.name - return the name of the value that this object contains\n
    argv.type - return the lldb.SBType for this value
    argv.type_name - return the name of the type
    argv.size - return the byte size of this value
    argv.is_in_scope - return true if this value is currently in scope
    argv.is_pointer - return true if this value is a pointer
    argv.format - return the current format for this value
    argv.value - return the value's value as a string
    argv.summary - return a summary of this value's value
    argv.description - return the runtime description for this value
    argv.location - return a string that represents the values location
        (address, register, etc)
    argv.target - return the lldb.SBTarget for this value
    argv.process - return the lldb.SBProcess for this value
    argv.thread - return the lldb.SBThread for this value
    argv.frame - return the lldb.SBFrame for this value
    argv.num_children - return the number of children this value has
    argv.children - return a list of sbvalue objects that represents all
        of the children of this value
    """

    def __init__(self, sbvalue):
        self.sbvalue = sbvalue

    def __nonzero__(self):
        return self.sbvalue.__nonzero__()

    def __repr__(self):
        return self.sbvalue.__repr__()

    def __str__(self):
        return self.sbvalue.__str__()

    def __getitem__(self, key):
        if isinstance(key, int):
            return Value(
                self.sbvalue.GetChildAtIndex(
                    key, lldb.eNoDynamicValues, True))
        raise TypeError

    def __getattr__(self, name):
        if name == 'name':
            return self.sbvalue.GetName()
        if name == 'type':
            return self.sbvalue.GetType()
        if name == 'type_name':
            return self.sbvalue.GetTypeName()
        if name == 'size':
            return self.sbvalue.GetByteSize()
        if name == 'is_in_scope':
            return self.sbvalue.IsInScope()
        if name == 'is_pointer':
            return self.sbvalue.TypeIsPointerType()
        if name == 'format':
            return self.sbvalue.GetFormat()
        if name == 'value':
            return self.sbvalue.GetValue()
        if name == 'summary':
            return self.sbvalue.GetSummary()
        if name == 'description':
            return self.sbvalue.GetObjectDescription()
        if name == 'location':
            return self.sbvalue.GetLocation()
        if name == 'target':
            return self.sbvalue.GetTarget()
        if name == 'process':
            return self.sbvalue.GetProcess()
        if name == 'thread':
            return self.sbvalue.GetThread()
        if name == 'frame':
            return self.sbvalue.GetFrame()
        if name == 'num_children':
            return self.sbvalue.GetNumChildren()
        if name == 'children':
            # Returns an array of sbvalue objects, one for each child of
            # the value for the lldb.SBValue
            children = []
            for i in range(self.sbvalue.GetNumChildren()):
                children.append(
                    Value(
                        self.sbvalue.GetChildAtIndex(
                            i,
                            lldb.eNoDynamicValues,
                            True)))
            return children
        raise AttributeError


class Variable(object):
    """A class that treats a lldb.SBValue and allows it to be used just as
    a variable would be in code. So if you have a Point structure variable
    in your code, you would be able to do: "pt.x + pt.y"""

    def __init__(self, sbvalue):
        self.sbvalue = sbvalue

    def __nonzero__(self):
        return self.sbvalue.__nonzero__()

    def __repr__(self):
        return self.sbvalue.__repr__()

    def __str__(self):
        return self.sbvalue.__str__()

    def __getitem__(self, key):
        # Allow array access if this value has children...
        if isinstance(key, int):
            return Variable(
                self.sbvalue.GetValueForExpressionPath(
                    "[%i]" %
                    key))
        raise TypeError

    def __getattr__(self, name):
        child_sbvalue = self.sbvalue.GetChildMemberWithName(name)
        if child_sbvalue:
            return Variable(child_sbvalue)
        raise AttributeError

    def __add__(self, other):
        return int(self) + int(other)

    def __sub__(self, other):
        return int(self) - int(other)

    def __mul__(self, other):
        return int(self) * int(other)

    def __floordiv__(self, other):
        return int(self) // int(other)

    def __mod__(self, other):
        return int(self) % int(other)

    def __divmod__(self, other):
        return int(self) % int(other)

    def __pow__(self, other):
        return int(self) ** int(other)

    def __lshift__(self, other):
        return int(self) << int(other)

    def __rshift__(self, other):
        return int(self) >> int(other)

    def __and__(self, other):
        return int(self) & int(other)

    def __xor__(self, other):
        return int(self) ^ int(other)

    def __or__(self, other):
        return int(self) | int(other)

    def __div__(self, other):
        return int(self) / int(other)

    def __truediv__(self, other):
        return int(self) / int(other)

    def __iadd__(self, other):
        result = self.__add__(other)
        self.sbvalue.SetValueFromCString(str(result))
        return result

    def __isub__(self, other):
        result = self.__sub__(other)
        self.sbvalue.SetValueFromCString(str(result))
        return result

    def __imul__(self, other):
        result = self.__mul__(other)
        self.sbvalue.SetValueFromCString(str(result))
        return result

    def __idiv__(self, other):
        result = self.__div__(other)
        self.sbvalue.SetValueFromCString(str(result))
        return result

    def __itruediv__(self, other):
        result = self.__truediv__(other)
        self.sbvalue.SetValueFromCString(str(result))
        return result

    def __ifloordiv__(self, other):
        result = self.__floordiv__(self, other)
        self.sbvalue.SetValueFromCString(str(result))
        return result

    def __imod__(self, other):
        result = self.__and__(self, other)
        self.sbvalue.SetValueFromCString(str(result))
        return result

    def __ipow__(self, other):
        result = self.__pow__(self, other)
        self.sbvalue.SetValueFromCString(str(result))
        return result

    def __ipow__(self, other, modulo):
        result = self.__pow__(self, other, modulo)
        self.sbvalue.SetValueFromCString(str(result))
        return result

    def __ilshift__(self, other):
        result = self.__lshift__(self, other)
        self.sbvalue.SetValueFromCString(str(result))
        return result

    def __irshift__(self, other):
        result = self.__rshift__(self, other)
        self.sbvalue.SetValueFromCString(str(result))
        return result

    def __iand__(self, other):
        result = self.__and__(self, other)
        self.sbvalue.SetValueFromCString(str(result))
        return result

    def __ixor__(self, other):
        result = self.__xor__(self, other)
        self.sbvalue.SetValueFromCString(str(result))
        return result

    def __ior__(self, other):
        result = self.__ior__(self, other)
        self.sbvalue.SetValueFromCString(str(result))
        return result

    def __neg__(self):
        return -int(self)

    def __pos__(self):
        return +int(self)

    def __abs__(self):
        return abs(int(self))

    def __invert__(self):
        return ~int(self)

    def __complex__(self):
        return complex(int(self))

    def __int__(self):
        return self.sbvalue.GetValueAsSigned()

    def __long__(self):
        return self.sbvalue.GetValueAsSigned()

    def __float__(self):
        return float(self.sbvalue.GetValueAsSigned())

    def __oct__(self):
        return '0%o' % self.sbvalue.GetValueAsSigned()

    def __hex__(self):
        return '0x%x' % self.sbvalue.GetValueAsSigned()


def print_graph(g):
    graph = Variable(g)
    print(graph.m_nodes)


# NOTE:
# this shows that it is possible to inspect an object,
# getting its property (data member)
# de-reference its data member to another object and so on...
# until I get all the information I need

# Note #2
# lldb's breakpoint callback system is similar to GDB's and
# is not coupled with python;
# I should try to use native lldb commands as much as I can since it has
# built-in STL beautifier
# see: https://lldb.llvm.org/varformats.html
def print_params():
    """
    automation:

    lldb -- /tmp/ticc/_
    br set -n core::Node::compute
    script import graph_printer_lldb
    br command add 1.1
    script graph_printer_lldb.print_params()
    continue
    DONE
    pr la

    """
    this = lldb.frame.FindVariable("this")
    ref = this.deref
    param = ref.GetChildMemberWithName('m_params')
    print(param)
