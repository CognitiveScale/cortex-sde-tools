import argparse
import sys
import os


def main():
    args = parse_args()
    try:
        jsonString = args.input.read()
        outputHandle = args.output
        print("MOCK DONE")
    finally:
        args.input.close()
        args.output.close()
        os._exit(0)


def parse_args():
    parser = argparse.ArgumentParser(description = 'run psa OR model')
    parser.add_argument(
        '--input', nargs='?', type=argparse.FileType('r', encoding='UTF-8'), default=sys.stdin) 
    parser.add_argument(
        '--output', nargs='?', type=argparse.FileType('w', encoding='UTF-8'), default=sys.stdout) 
    return parser.parse_args()
   
 
if __name__ == '__main__':
    main()
