
/*

This class solves the following problem:
to a dictionary, we want to be able to add an object normally, but when the key exists, we want to accumulate the items to an array. If we add an array, the items in the array should be accumulated as well.

The Bag class is similar, but does not use keys to store items, so this class is an Environment that behaves like a Bag in some respect.

*/

BagEnvirNode : List {

	isBagNode {
		^true
	}

	add { |item|
		if(item.isBagNode) {
			item.do { |x| super.add(x) }
		} {
			super.add(item)
		}
	}

	asBagEnvirNode {
		^this
	}

	selectFromBagEnvirNode { |choiceFunc|
		^if(choiceFunc.notNil) { choiceFunc.value(this) } { array.copy }
	}
}


BagEnvironment : Environment {

	put { |key, item|
		var existing = this[key];
		if(existing.isNil) {
			super[key] = item
		} {
			super[key] = existing.asBagEnvirNode.add(item)
		}
	}

	replaceAt { |key, item|
		super.removeAt(key);
		super.put(key, item);
	}

	get { |key, choiceFunc|
		^this[key].selectFromBagEnvirNode(choiceFunc)
	}

	do { |func|
		var j = 0;
		super.do { |val, i|
			if(val.isBagNode) {
				val.do { |each|
					func.value(each, j, i);
					j = j + 1;
				}
			} {
				func.value(val, j, i);
				j = j + 1;
			}
		}
	}

	keysValuesDo { |func|
		super.keysValuesDo { |key, val|
			if(val.isBagNode) {
				val.do { |each|
					func.value(key, each)
				}
			} {
				func.value(key, val)
			}
		}
	}

	removeAt { |key|
		var item = this[key], res;
		^if(item.isBagNode) {
			res = item.pop;
			if(item.size <= 1) {
				super.put(key, item[0])
			};
			res
		} {
			super.removeAt(key)
		}
	}

}


+ Object {

	isBagNode {
		^false
	}

	asBagEnvirNode {
		^BagEnvirNode.new.add(this)
	}

	selectFromBagEnvirNode {
		^this
	}
}
