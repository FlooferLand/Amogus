extends Node

func snappy_boi(value, snap: int = 64):
	return (snap * round(float(value) / snap))
