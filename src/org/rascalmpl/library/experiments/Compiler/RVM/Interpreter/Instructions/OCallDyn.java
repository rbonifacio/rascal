package org.rascalmpl.library.experiments.Compiler.RVM.Interpreter.Instructions;

import org.eclipse.imp.pdb.facts.ISourceLocation;
import org.rascalmpl.library.experiments.Compiler.RVM.Interpreter.CodeBlock;

public class OCallDyn extends Instruction {
	
	final int arity;
	final int types;
	final ISourceLocation src;
	
	public OCallDyn(CodeBlock ins, int types, int arity, ISourceLocation src) {
		super(ins, Opcode.OCALLDYN);
		this.arity = arity;
		this.types = types;
		this.src = src;
	}
	
	public String toString() { return "OCALLDYN " + types + ", " + arity + " " + src; }
	
	public void generate(){
		codeblock.addCode2(opcode.getOpcode(), types, arity);
		codeblock.addCode(codeblock.getConstantIndex(src));
	}
}
