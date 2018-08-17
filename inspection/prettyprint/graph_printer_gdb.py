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


def init():
    pp = gdb.printing.RegexpCollectionPrettyPrinter('')
    pp.add_printer('core-graph', 'core::graph::Graph', CoreGraphPrinter)
    gdb.printing.register_pretty_printer(None, pp)
