package org.rascalmpl.ast; 
import org.eclipse.imp.pdb.facts.INode; 
public abstract class TagChar extends AbstractAST { 
  static public class Lexical extends TagChar {
	private final String string;
         protected Lexical(INode node, String string) {
		this.node = node;
		this.string = string;
	}
	public String getString() {
		return string;
	}

 	public <T> T accept(IASTVisitor<T> v) {
     		return v.visitTagCharLexical(this);
  	}
} static public class Ambiguity extends TagChar {
  private final java.util.List<org.rascalmpl.ast.TagChar> alternatives;
  protected Ambiguity(INode node, java.util.List<org.rascalmpl.ast.TagChar> alternatives) {
	this.alternatives = java.util.Collections.unmodifiableList(alternatives);
         this.node = node;
  }
  public java.util.List<org.rascalmpl.ast.TagChar> getAlternatives() {
	return alternatives;
  }
  
  public <T> T accept(IASTVisitor<T> v) {
     return v.visitTagCharAmbiguity(this);
  }
} public abstract <T> T accept(IASTVisitor<T> visitor);
}