# V2
class_name BitUtils


static func bit_to_mask(bit: int) -> int:
	return 1 << (bit - 1)

	
static func bit_array_to_mask(bits: Array[int]) -> int:
	var mask: int = 0
	for bit in bits:
		mask |= 1 << (bit - 1)
	return mask
