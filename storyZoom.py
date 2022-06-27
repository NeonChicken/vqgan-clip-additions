import sys

if sys.argv[1] == "convert":
	print(float(sys.argv[2]) / 100)
	sys.exit(0)

print(f"{sys.argv[1]}")
	
sys.exit(0)