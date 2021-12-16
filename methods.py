def adjustValue(val):
    if len(val)<9:
        val='0'*(9-len(val))+val
    val=list(val)
    val.insert(-8,'.')
    val=''.join(val)
    return float(val)
