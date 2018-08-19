"""

related articles:
https://stackoverflow.com/questions/7060099/how-to-call-constructor-in-gdb-for-pretty-printers
(see the second answer)
https://stackoverflow.com/questions/43520104/gdb-pretty-print-class-containing-stl-container
(see how it uses the std::set printer in python)

this can be helpeful
https://stackoverflow.com/questions/8578320/gdb-pretty-printing-with-direct-function-calls

"""


import gdb.printing
import gdb


class CoreGraphPrinter(object):

    def __init__(self, val):
        self.val = val

    # NOTE: access vector member is not straight forward
    # but I can use the address trick to calculate the size
    def to_string(self):
        start_addr = self.val['m_nodes']['_M_impl']['_M_start']
        finish_addr = self.val['m_nodes']['_M_impl']['_M_finish']
        return 'core-graph, nodes: {}'.format(finish_addr - start_addr)


class NodePrinter(object):

    def __init__(self, val):
        self.val = val

    def to_string(self):
        return 'pp called'


def init():
    # the first argument to ctor is the name of
    # RegexpCollectionPrettyPrinter object;
    pp = gdb.printing.RegexpCollectionPrettyPrinter('test-project')

    # the first argument to ctor is the name of the pretty-printer;
    # the second argument is a regex pattern;
    pp.add_printer('core-graph', 'core::graph::Graph', CoreGraphPrinter)
    pp.add_printer('core-node', 'core::Node', NodePrinter)

    # the first argument is the scope - I can use an object here;
    # using None means global scope
    gdb.printing.register_pretty_printer(None, pp)
