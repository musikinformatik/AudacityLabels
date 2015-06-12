
/*

this extension solves the following problem:
to a dictionary, we want to be able to add an object normally, but when the key exists, we want to accumulate the items to an array. If we add an array, the items in the array should be accumulated as well.

*/

AccumulatingNode : List {

	add { |item|
		if(item.isKindOf(this.class)) {
			item.do { |x| super.add(x) }
		} {
			super.add(item)
		}
	}

	asAccumulatingNode {
		^this
	}

	chooseFromAccumulatingNode { |choiceFunc|
		^if(choiceFunc.notNil) { choiceFunc.value(this) } { this.choose }
	}
}


AccumulatingIdentityDictionary : IdentityDictionary {

	put { |key, item|
		var existing = this[key];
		if(existing.isNil) {
			super[key] = item
		} {
			super[key] = existing.asAccumulatingNode.add(item)
		}
	}

	get { |key, choiceFunc|
		^this[key].chooseFromAccumulatingNode(choiceFunc)
	}

}


+ Object {

	asAccumulatingNode {
		^AccumulatingNode.new.add(this)
	}

	chooseFromAccumulatingNode {
		^this
	}
}