package org.rascalmpl.ast; 
import org.eclipse.imp.pdb.facts.INode; 
public abstract class OctalEscapeSequence extends AbstractAST { 
  static public class Lexical extends OctalEscapeSequence {
	private final String string;
         protected Lexical(INode node, String string) {
		this.node = node;
		this.string = string;
	}
	public String getString() {
		return string;
	}

 	public <T> T accept(IASTVisitor<T> v) {
     		return v.visitOctalEscapeSequenceLexical(this);
  	}
} static public class Ambiguity extends OctalEscapeSequence {
  private final java.util.List<org.rascalmpl.ast.OctalEscapeSequence> alternatives;
  protected Ambiguity(INode node, java.util.List<org.rascalmpl.ast.OctalEscapeSequence> alternatives) {
	this.alternatives = java.util.Collections.unmodifiableList(alternatives);
         this.node = node;
  }
  public java.util.List<org.rascalmpl.ast.OctalEscapeSequence> getAlternatives() {
	return alternatives;
  }
  
  public <T> T accept(IASTVisitor<T> v) {
     return v.visitOctalEscapeSequenceAmbiguity(this);
  }
} public abstract <T> T accept(IASTVisitor<T> visitor);
}